describe 'for unsupported operating system families' do
let(:facts) { { :osfamily => 'Unsupported' } }
it { expect{ subject }.to raise_error(/^The windows_xmltask module is not supported on Unsupported systems/)}
end
