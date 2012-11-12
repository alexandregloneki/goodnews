class ReturnPaymentsController < ApplicationController
  # GET /payments
  # GET /payments.json
  skip_before_filter :verify_authencity_token
  def confirm
    Rails.logger.add_metadata({:ret =>'checg'})
    begin
      return unless request.post?
      pagseguro_notification do |notification|
       raise Rails.logger.add_metadata({:ret =>'not inv'}) unless notification_valid?
       @order = Order.find_by_id(params["Referencia"])
       raise Rails.logger.add_metadata({:ret =>'pedido nao encontrado'}) if @order.nil?
       raise Rails.logger.add_metadata({:ret =>'pedido valor invalido'}) unless @order.plan.value==params["ProdValor_1"]
        if notification.status=='approved'
          Rails.logger.add_metadata({:ret =>'ok'})
          render :text=>'ok'
        end
      end
     rescue 
       Rails.logger.add_metadata({:ret =>'erro'})
     end
  end
end