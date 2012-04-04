require 'spec_helper'

describe "email_updates/index" do
  before(:each) do
    assign(:email_updates, [
      stub_model(EmailUpdate,
        :subject => "Subject",
        :message => "Message"
      ),
      stub_model(EmailUpdate,
        :subject => "Subject",
        :message => "Message"
      )
    ])
  end

  it "renders a list of email_updates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Message".to_s, :count => 2
  end
end
