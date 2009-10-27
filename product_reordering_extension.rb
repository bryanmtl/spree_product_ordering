# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ProductReorderingExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/product_reordering"

  # Please use product_reordering/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    
    Product.class_eval do
      acts_as_list
      default_scope :order => "position"
      named_scope :ordered, :order => 'position'
    end
    
    
    
    Admin::ProductsController.class_eval do
          
      def reorder
        @products = Product.active.find(:all, :order => 'position')
      end
      
      def order_products
        
        params[:item_list].each_with_index do |id, index|
            Product.update_all(['position=?', index+1], ['id=?', id])
          end

          respond_to do |format|
            format.js do 
              render :update do |page|
                page.visual_effect :highlight, "item_list"
              end
            end
          end  
      end
    end

    # Add your extension tab to the admin.
    # Requires that you have defined an admin controller:
    # app/controllers/admin/yourextension_controller
    # and that you mapped your admin in config/routes

    #Admin::BaseController.class_eval do
    #  before_filter :add_yourextension_tab
    #
    #  def add_yourextension_tab
    #    # add_extension_admin_tab takes an array containing the same arguments expected
    #    # by the tab helper method:
    #    #   [ :extension_name, { :label => "Your Extension", :route => "/some/non/standard/route" } ]
    #    add_extension_admin_tab [ :yourextension ]
    #  end
    #end

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
