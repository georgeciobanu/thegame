require 'spec_helper'

describe "email_updates/edit" do
  before(:each) do
    @email_update = assign(:email_update, stub_model(EmailUpdate,
      :subject => "MyString",
      :message => "MyString"
    ))
  end

  it "renders the edit email_update form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => email_updates_path(@email_update), :method => "post" do
      assert_select "input#email_update_subject", :name => "email_update[subject]"
      assert_select "input#email_update_message", :name => "email_update[message]"
    end
  end
end
