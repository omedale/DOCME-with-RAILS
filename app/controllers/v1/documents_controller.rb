require 'pry'
module V1
  class DocumentsController < ApplicationController
    before_action :set_document, only: %i[show update destroy]

    def index
      return custom_response('document', 401) if params[:user_id].to_i != current_user.id.to_i && !admin?

      docs = Rails.cache.fetch("all_docs") do
        if admin?
          docs = Document.all
        else
          docs = Document.where("(user_id = ?) OR (access = ?)", current_user.id, 'public')
                                .paginate(page: params[:page], per_page: 20)
        end
        docs
      end
      return custom_response('document', 404) if docs.empty?

      return json_response(docs, 200)
    end

    def search
      if params[:q]
        @document = Document.search(params[:q], current_user.id, current_user.role).paginate(page: params[:page], per_page: 20)

        return custom_response('document', 404)  if @document.empty?

        return json_response(@document, :ok)
      else
        return custom_response('document', 400) 
      end
    end

    def show
      return json_response(@document, 200) if admin? || @document[:access] == current_user.role.role || @document[:access] == 'public' || @document[:user_id] == current_user.id

      return custom_response('document', 401) 
    end

    def create
      custom_response('document', 401) if params[:user_id].to_i != current_user.id.to_i

      unless params[:access]
        return json_response({ message: 'Please Specify Access' }, 500)
      end

      if params[:access] == 'public' || params[:access] == 'private' ||  params[:access] == get_user_role
        @document = Document.create!(
          title: params[:title],
          content: params[:content],
          owner: current_user.name,
          access: params[:access],
          user_id: current_user.id
          )
          data = {
            id: @document.id,
            title: @document.title,
            content: @document.content,
            owner: @document.owner,
            access: @document.access,
            message: 'Document Created Successfully'
          }
          return json_response(data, 201)

      else  
        return json_response({ message: 'Access should be public, private or your role' }, 500)
      end
    end

    def update
      if admin? || @document[:user_id] == current_user.id
        @document.attributes = document_params
        return json_response({ message: 'Document Updated Succefully' }, :ok) if @document.save(validate: false)
        return json_response(@document.errors, :bad)
      end
      custom_response('document', 401)
    end

    def destroy
      if admin? || @document[:user_id] == current_user.id
        return json_response({ message: 'Document Deleted Succefully' }, :ok) if @document.destroy
        return json_response(@document.errors, :bad)
      end
      custom_response('document', 401)
    end

    private

    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.permit(:title, :content, :access)
    end
  end
end