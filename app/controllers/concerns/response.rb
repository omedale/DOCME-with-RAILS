module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def custom_response(model_type, status = :ok)
    unauthorized_message = 'Unauthorized Access'
    not_found_message = "#{model_type} not Found"
    search_error_message = "No search key, Use routes \'/#{model_type}/search/{search value}\'"
    if status == 404
      render json: { message: not_found_message, status: status }
    elsif status == 401
      render json: { message: unauthorized_message, status: status }
    elsif status == 400
      render json: { message: search_error_message, status: status }
    else
      render json: { status: status }
    end
  end
end
