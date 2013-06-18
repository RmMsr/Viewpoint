require_relative '../spec_helper'

describe Viewpoint::EWS::SOAP::EwsBuilder do
  include Viewpoint::EWS::SOAP
  before do
    @builder = described_class.new
    @namespaces = Viewpoint::EWS::SOAP::NAMESPACES
  end

  it 'should build BodyType' do
    doc = @builder.build! do |section|
      if section == :body
        @builder.body_type!(:html)
        @builder.body_type!(:text)
        @builder.body_type!(:best)
      end
    end
    doc.xpath('//t:BodyType[1]').text.should eq('HTML')
    doc.xpath('//t:BodyType[2]').text.should eq('Text')
    doc.xpath('//t:BodyType[3]').text.should eq('Best')
  end

  it 'should contain exchange impersonation' do
    doc = @builder.build!(impersonation: {principal_name: 'user'})
    selector = "//soap:Header/t:ExchangeImpersonation/t:ConnectingSID/t:PrincipalName[text()='user']"
    doc.root.xpath(selector, @namespaces).should be_any
  end

end
