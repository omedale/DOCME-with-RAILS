class DocumentsController < ApplicationController
  def index
    @document = Document.all
    json_response(@document)
  end
end
