(function($) {
    var type_cel = "M";
    var nextel = new Array('70', '77', '78', '79');
    $.fn.extend({
        repair: function(objeto, name_object){
           
            function limpar_mascara(start, twoFirstNumber, e, objeto, name_object, ddd){
                switch(start){
                    case 5:
                        if (twoFirstNumber=="__" && (e.which=='8' || e.which=='46') && ddd=='11')    limpar(objeto, name_object);
                    break;
                    case 6:
                        if ((e.which=='8' || e.which=='46') && ddd=='11')    limpar(objeto, name_object);
                    break;
                }
                if (objeto.val().substring(1, 2)=="_"){
                     objeto.removeClass('celularsp');
                     objeto.val('');
                     objeto.unmask();
                     objeto.mask("(99) 9999-9999");
                     var elemento = document.getElementById(name_object);
                     elemento.focus();
                }
            }
            function limpar_toda_mascara(objeto, name_object){
                objeto.removeClass('celularsp');
                objeto.val('');
                objeto.unmask();
                objeto.mask("(99) 9999-9999");
                var elemento = document.getElementById(name_object);
                elemento.focus();
            }
           
            function limpar(objeto, name_object){
                objeto.removeClass('celularsp');
                objeto.unmask();
                objeto.mask("(99) 9999-9999", [], undefined, true);
                objeto.val('(11) _____-____');
                var elemento = document.getElementById(name_object);
                elemento.focus();
                elemento.setSelectionRange(5, 5);
            }
            function build_new_buffer(objeto){
                var positionFirstDdd = new Array(5, objeto.val().substring(5, 6));
                var positionSecondDdd = new Array(6, objeto.val().substring(6, 7));
                return new Array(positionFirstDdd, positionSecondDdd);
            }
           
            function set_new_buffer(objeto, newbuffer, twoFirstNumber){
                objeto.removeClass('telefone');
                objeto.addClass('celularsp');
                objeto.unmask();
                objeto.mask("(99) 99999-9999", [], newbuffer, true);
                objeto.val( '(11) '+twoFirstNumber+'___-____' );
            }
           
            function position_new_buffer(name_object){
                var elementoNew = document.getElementById(name_object);
                if(elementoNew != null) {
                     if(elementoNew.createTextRange) {
                         var range = elementoNew.createTextRange();
                         range.move('character', 5);
                         range.select();
                     }
                     else {
                   
                         if(elementoNew.selectionStart) {
                             elementoNew.focus();
                             elementoNew.setSelectionRange(7, 7);
                         }
                         else
                             elementoNew.focus();
                     }
                }
            }
           
            jQuery("input.telefone").mask("(99) 9999-9999");
            jQuery("input.celularsp").mask("(99) 99999-9999");
           
            objeto.keyup(function(e){
                
                    var ddd = objeto.val().substring(1, 3);
                    var start = objeto[0].selectionStart
                    var twoFirstNumber = objeto.val().substring(5, 7);
                    limpar_mascara(start, twoFirstNumber, e, objeto, name_object, ddd);
                    if(objeto.hasClass('celularsp')) return;
                    if(ddd == '11' ){
                        if (start=='7' && jQuery.inArray(twoFirstNumber, nextel)==-1){
                            var new_buffer = build_new_buffer(objeto);
                            set_new_buffer(objeto, new_buffer, twoFirstNumber);
                            position_new_buffer(name_object);
                        }
                    }
                
            });
           
            
        }
       
    });
})(jQuery);