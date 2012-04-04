require 'spec_helper'

describe "email_updates/show" do
  before(:each) do
    @email_update = assign(:email_update, stub_model(EmailUpdate,
      :subject => "Subject",
      :message => "Message"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Subject/)
    rendered.should match(/Message/)
  end
end
