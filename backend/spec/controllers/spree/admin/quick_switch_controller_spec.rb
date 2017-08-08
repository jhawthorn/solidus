require "spec_helper"

describe Spree::Admin::QuickSwitchController, type: :controller do
  stub_authorization!

  let!(:order) { FactoryGirl.create :order, number: "R1234" }
  let!(:product) { FactoryGirl.create :product, sku: "SKU123" }
  let!(:shipment) { FactoryGirl.create :shipment, number: "S1234" }
  let!(:variant) { FactoryGirl.create :variant, sku: "SKU456" }

  describe "POST #find_object" do
    let(:params) do
      {
        quick_switch_query: query
      }
    end

    subject { post :find_object, params: params }

    context "with a valid query" do
      context "for an order" do
        let(:query) { "o R1234" }

        it "redirects the user to the order's edit page" do
          expect(subject).to redirect_to spree.edit_admin_order_path(order)
        end
      end

      context "for a product" do
        let(:query) { "p SKU123" }

        it "redirects the user to the product's edit page" do
          expect(subject).to redirect_to spree.edit_admin_product_path(product)
        end
      end

      context "for a shipment" do
        let(:query) { "s S1234" }

        it "redirects the user to the shipment's edit page" do
          expect(subject).to redirect_to spree.edit_admin_order_path(shipment.order)
        end
      end

      context "for a variant" do
        let(:query) { "v SKU456" }

        it "redirects the user to the variant's edit page" do
          expect(subject).to redirect_to spree.edit_admin_product_variant_path(
            variant.product, variant
          )
        end
      end
    end

    context "with a query that does not have an object defined" do
      before { request.env["HTTP_REFERER"] = "back" }

      let(:query) { "R1234" }

      it "redirects back to the previous page" do
        expect(subject).to redirect_to "back"
      end

      it "renders a flash message explaining what went wrong" do
        subject
        expect(flash[:error]).to eq "Invalid or missing search key."
      end
    end

    context "when a record cannot be found" do
      before { request.env["HTTP_REFERER"] = "back" }

      let(:query) { "o X1234" }

      it "redirects back to the previous page" do
        expect(subject).to redirect_to "back"
      end

      it "renders a flash message explaining what couldn't be found" do
        subject
        expect(flash[:error]).to eq "Order X1234 could not be found."
      end
    end
  end
end
