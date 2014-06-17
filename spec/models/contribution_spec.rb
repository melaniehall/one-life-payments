require 'spec_helper'

describe Contribution, "columns" do
  it { should have_db_column(:amount) }
  it { should have_db_column(:amount_cents)}
  it { should have_db_column(:stripe_token)}
  it { should have_db_column(:stripe_currency) }
  it { should have_db_column(:monthly)}
  it { should have_db_column(:stripe_id)}
  it { should have_db_column(:first_name)}
  it { should have_db_column(:last_name) }
  it { should have_db_column(:email)}
  it { should have_db_column(:contributor_id) }
  it { should have_db_column(:address_line1) }
  it { should have_db_column(:address_line2) }
  it { should have_db_column(:address_city) }
  it { should have_db_column(:address_state) }
  it { should have_db_column(:address_zip) }
  it { should have_db_column(:address_country) }
  it { should have_db_column(:gift_designation) }
end