module ApplicationHelper

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end
  
  def breadcumb (options = {})
    breadcumb = '<ul class="breadcrumb">'
      options.each do |op|
        breadcumb +=
        "<li><a class'pjax' href='/#{op[:caminho]}/'>#{op[:exibicao]}</a></li>
        <span class='divider'>/</span>"
      end
    breadcumb +='</ul>'
    breadcumb.html_safe
  end

  def tabs(options = {})
    tabs = "<ul class='nav nav-tabs'>"
    options.each do |op|
        active = 'active' if op[:active]
        tabs +=
          "<li class='icon index_collection_link #{active}' rel='' title=''>
              <a href='/#{op[:caminho]}' class='pjax'><i class='#{op[:icon]}'></i>
                <span>#{op[:exibicao]}</span>
              </a>
          </li>"
    end
    tabs+="</ul>"
    tabs.html_safe
  end
  
  def filter(options = {})
    form = "<form method='get' class='pjax-form form-inline' action='/#{options[:action]}/' accept-charset='UTF-8'><div style='margin:0;padding:0;display:inline'>
            <div class='well'>
            <span id='filters_box'></span>
            <hr style='display:none' class='filters_box'>
            <input type='search' placeholder='Filter' name='query' class='input-small'>
            <button type='submit' data-disable-with='&lt;i class=icon-white icon-refresh/&gt;&lt;/i&gt; Refresh'  class='btn btn-primary''>
              <i class='icon-white icon-refresh'></i>Refresh
            </button>
            <span style='float:right'><a class='btn btn-info[disabled]' href='#{options[:link]}'>Exportar dados</a></span></div></form>"
    form.html_safe
  end
  
  def actions(options={})
   
   buttons = "<div class='form-actions'>
                <button type='submit' name='sub' data-disable-with='Salvar' class='btn btn-primary' value='save'>
                  <i class='icon-white icon-ok'></i>
                  Salvar
                </button>
                <span class='extra_buttons'>
                  <button type='submit' name='sub' data-disable-with='Salvar e adicionar' class='btn btn-info' value='saveadd'>
                  Salvar e adicionar novo
                  </button>
                  <button type='submit' name='sub' data-disable-with='Salvar e editar' class='btn btn-info' value='saveedit'>
                  Salvar e editar
                  </button>
                  <button type='submit' name='sub' data-disable-with='Cancelar' class='btn'>
                  <i class='icon-remove'></i>
                  Cancelar
                  </button>
                </span>
              </div>" 
  buttons.html_safe
  end
  
  def actions_export(options={})
   
   buttons = "<div class='form-actions'>
                <button type='submit' name='csv' class='btn btn-primary' id='csv'>
                  <i class='icon-white icon-ok'></i>
                  Export to csv
                </button>
                <span class='extra_buttons'>
                  <button type='submit' name='json' class='btn btn-info' id='json'>
                  Export to json
                  </button>
                  <button type='submit' name='xml' class='btn btn-info' id='xml'>
                  Export to xml
                  </button>
                  <button type='submit' name='_continue' class='btn' id='cancel'>
                  <i class='icon-remove'></i>
                  Cancel
                  </button>
                </span>
              </div>" 
  buttons.html_safe
  end
    
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class=>"btn")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class=>"btn", :name=>'add_rule')
  end
  
  def get_action(btn, id)
    case btn
      when  'save' then id
      when  'saveadd' then 'new'
      when 'saveedit' then "#{id}/edit"
    end
  end
  
  def mensagens_vencimento(datavencimento, data_cria, status)
    
    if datavencimento.to_date < Date.today && status.to_i==6
      retorno = "<div class='alert alert-error'>Sua fatura venceu na data #{datavencimento.to_date}, realize o pagamento e ative novamente sua conta</div>"
    end
    if datavencimento.to_date > Date.today && status.to_i==6
      retorno = "<div class='alert alert-success'>Sua fatura e valida, ate #{datavencimento.to_date}</div>"
    end
    
    if status.to_i==5
      retorno = "<div class='alert'>Realize o pagamento da fatura e ative sua conta, caso contrario sua conta sera cancelada</div>"
    end
    return retorno.html_safe
  end
end
