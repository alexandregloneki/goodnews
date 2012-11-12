def breadcumb (options ={})
  
  breadcumb = 
  '<ul class="breadcrumb">'
    options.each do |op|
      '<li>
        <a class="pjax" href="/#{op[:caminho]}/">#{op[:exibicao]}</a>
      </li>
      <span class="divider">/</span>'
    end
  '</ul>'
end