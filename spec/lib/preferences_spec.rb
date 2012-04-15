require_relative '../../lib/preferences'

describe HH::Preferences do
  it "behaves like a hash" do
    subject[:key] = :value
    subject[:key].should eql(:value)
  end

  it "is able to be saved" do
    HH::Database.should_receive(:new).twice.and_return(stub(:load => [], :save => true))
    subject.save
  end
end
