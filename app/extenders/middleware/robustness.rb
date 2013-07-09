# Intercepts excpetion from the middlewares to handled those as JSON responses
class Robustness

  def initialize(app)
    @app = app
  end

  # Rack API call for rescue from the exceptions
  def call(env)
    @app.call(env)
  rescue Apartment::SchemaNotFound => ex
    [422, { 'Content-Type' => 'application/json' }, [ {errors: {subdomain:["Invalid subdomain"]}}.to_json ] ]  # suppose the message can be safely used
  rescue SecurityError => ex
    [403, { 'Content-Type' => 'application/json' }, [ ex.message ] ]
  ensure
    env['rack.errors'].write(ex.message) if ex
  end

end