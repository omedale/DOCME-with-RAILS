class NotFoundController < ApplicationController
  def index
    status = 404
    data = { message: 'Route Not Found' }
    json_response(data, status)
  end
end
