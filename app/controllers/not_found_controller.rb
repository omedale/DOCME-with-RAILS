class NotFoundController < ApplicationController
  def index
    status = 404
    obj = {message: 'Not Found'}
    json_response(obj, status)
  end
end
