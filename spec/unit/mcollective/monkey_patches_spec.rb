require 'spec_helper'

require 'mcollective/monkey_patches'

describe OpenSSL::SSL::SSLContext do
  it 'sets parameters on initialization' do
    described_class.any_instance.expects(:set_params).at_least_once
    subject
  end

  it 'disables SSLv2 via the SSLContext#options bitmask' do
    expect(subject.options & OpenSSL::SSL::OP_NO_SSLv2).to eq(OpenSSL::SSL::OP_NO_SSLv2)
  end

  it 'explicitly disable SSLv2 ciphers using the ! prefix so they cannot be re-added' do
    if OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers]
      described_class.any_instance.expects(:set_params).with { |params| params[:ciphers].split(':').include?('!SSLv2') }
      subject
    end
  end

  # Only the older openssl gems, up to the 3.2 releases, replace the options in
  # set_params, so this example guards the bare set_params call of puppet's patch
  # on Ruby 3.3 and older
  it 'keeps SSLv3 disabled and empty fragments enabled after set_params runs again without options' do
    subject.set_params

    expect(subject.options & OpenSSL::SSL::OP_NO_SSLv3).to eq(OpenSSL::SSL::OP_NO_SSLv3)
    expect(subject.options & OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS).to eq(OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS)
  end

  it 'keeps empty fragments enabled via the SSLContext#options bitmask' do
    expect(subject.options & OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS).to eq(OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS)
  end

  it 'has no ciphers with version SSLv2 enabled' do
    ciphers = subject.ciphers.select do |name, version, bits, alg_bits|
      /SSLv2/.match(version)
    end
    expect(ciphers).to be_empty
  end

  it 'disables SSLv3 via the SSLContext#options bitmask' do
    expect(subject.options & OpenSSL::SSL::OP_NO_SSLv3).to eq(OpenSSL::SSL::OP_NO_SSLv3)
  end

end
