require 'spec_helper'

RSpec.describe "Outstanding balance integration tests" do
  let!(:order) { create(:order_with_line_items) }
  before { order.update_attributes!(state: 'complete', completed_at: Time.now) }

  subject do
    order.update!
    order.outstanding_balance
  end

  context 'when the order is unpaid' do
    it { should == order.total }
    it { should == 110 }

    context 'when the order is cancelled' do
      before { order.cancel! }
      it { should == 0 }
    end
  end

  context 'when the order is fully paid' do
    let!(:payment) { create(:payment, :completed, order: order, amount: order.total) }
    it { should == 0 }

    context 'when the order is cancelled' do
      before { order.update_attributes!(state: "canceled") }
      it { should == -110 }

      context 'and the payment is voided' do
        before { payment.update_attributes!(state: "void") }
        it { should == 0 }
      end

      context 'and there is a refund' do
        let!(:refund) { create(:refund, payment: payment, amount: payment.amount) }
        it { should == 0 }
      end
    end
  end
end
