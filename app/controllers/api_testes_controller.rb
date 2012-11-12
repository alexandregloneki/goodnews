class ApiTestesController < ApplicationController
  def index
    @menu = {"01"=>
              ["01 - Enviar Parametros","#{APP_URL}/api_testes/view_send_data"].sort}.sort
    
    render :layout=>'api_testes'
  end
end