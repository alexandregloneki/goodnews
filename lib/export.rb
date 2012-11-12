require 'csv' 
class Export
  
  def self.csv_export(objeto, campos)
     
    csv_string = CSV.generate do |csv|
         csv << ["Id", "Title", "Status","CC", "CCO"]         
         objeto.each do |obj|
             csv << [obj.id, obj.title, obj.status.name, obj.cc, obj.cco] 
          end     
     end
     return csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=users.csv"
 end
  
end