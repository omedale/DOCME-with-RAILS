class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show destroy]

  def index
    if params[:user_id].to_i != current_user.id.to_i && current_user.role_id != 1
      obj = {
        message: 'Unauthorized Access'
      }
      return json_response(obj, 401)
    end

    user_role = Role.find(current_user.role_id)
    if current_user.role_id == 1 
      @document = Document.select(:id, :title, :content, :owner, :access, :created_at).paginate(page: params[:page], per_page: 20)
    else
      @document = Document.select(:id, :title, :content, :owner, :access, :created_at)
                            .where("(user_id = ?) OR (access = ? OR access = ?)", current_user.id, 'public', current_user.role)
                            .paginate(page: params[:page], per_page: 20)
    end
    if @document.empty?
      obj = {
        message: 'Documents not Found'
      }
      return json_response(obj, 404)
    end
    json_response(@document, 200)
  end

  def search
    if params[:q]
      @document = Document.search(params[:q], current_user.id, current_user.role).select(:id, :title, :content, :owner, :access, :created_at).paginate(page: params[:page], per_page: 20)

      if @document.empty?
        obj = {
          message: 'Documents not Found'
        }
        return json_response(obj, 404)
      end
      return json_response(@document, :ok)
    else
      obj = {
        message: 'No search key, Use routes \'/users/search/{search value}\''
      }
      return json_response(obj, :bad)
    end
  end

  def show
    if current_user.role_id == 1 || @document[:access] == current_user.role.role || @document[:access] == 'public' || @document[:user_id] == current_user.id
      return json_response(@document, 200)
    end
    obj = {
      message: 'Unauthorized Access'
    }
    return json_response(obj, 401)
  end

  def create
    if params[:user_id].to_i != current_user.id.to_i
      obj = {
        message: 'Unauthorized Access'
      }
      return json_response(obj, 401)
    end
    user_role = Role.find(current_user.role_id)
    unless params[:access]
      obj = {
        message: 'Please Specify Access'
      }
      return json_response(obj, 500)
    end

    if params[:access] == 'public' || params[:access] == 'private' ||  params[:access] == user_role.role
      @document = Document.create!(
        title: params[:title],
        content: params[:content],
        owner: current_user.name,
        access: params[:access],
        user_id: current_user.id
        )
        obj = {
          id: @document.id,
          title: @document.title,
          content: @document.content,
          owner: @document.owner,
          access: @document.access,
          message: 'Document Created Successfully'
        }
        return json_response(obj, 201)

    else  

      obj = {
        message: 'Access should be public, private or your role'
      }
      return json_response(obj, 500)
    end
  end

  def destroy
    if current_user.role_id == 1 || @document[:user_id] == current_user.id
      if @document.destroy
        obj = {
          message: 'Document Deleted Succefully'
        }
        return json_response(obj, :ok)
      end
      json_response(@document.errors, :bad)
    end
    obj = {
      message: 'Unauthorized Access'
    }
    return json_response(obj, 401)
  end

  private

  def set_document
    @document = Document.select(:id, :title, :content, :owner, :access, :user_id, :created_at).find(params[:id])
  end

  def document_params
    params.permit(:title, :content, :access)
  end
end
