class PaymentsController < ApplicationController
  
  
  def index
    @payments = Payment.all
    @plans = Plan.all
    @order = Order.first(:conditions=>{:account_id=>session[:account_id]})
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'payments', :exibicao=>'Pagamento'}]
    @tabsval = [{:caminho=>'payments', :exibicao=>'Pagamento',:active=>true, :icon=>'icon-shopping-cart' }]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end
  
  def checkout
    @account = Account.first(:conditions=>{:user_id=>current_user.id})
    @plan = Plan.find(params[:plan])
    @order_plan = Order.new(:account_id=>@account.id, :plan_id=>@plan.id, :status_id=>5)
    @order_plan.save!
  end
  
  def return_payment
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
