require "miq_performance/reporting/requestfile_builder"

describe MiqPerformance::Reporting::RequestfileBuilder do
  describe "::filepath" do
    let(:pwd) { Dir.pwd }

    context "default" do
      it "returns 'tmp/miq_performance' (defined in the config)" do
        expect(described_class.send(:filepath)).to eq("#{pwd}/tmp/miq_performance")
      end
    end

    context "with default_dir set" do
      it "returns 'my/miq_perf' as defined" do
        MiqPerformance.config.instance_variable_set :@default_dir, 'my/path'

        expect(described_class.send(:filepath)).to eq("#{pwd}/my/path")
      end
    end

    context "with default_dir set to an absolute path" do
      it "returns 'my/miq_perf' as an absolute path" do
        MiqPerformance.config.instance_variable_set :@default_dir, '/my/path'

        expect(described_class.send(:filepath)).to eq("/my/path")
      end
    end

    context "with requestfile_dir set" do
      before do
        conf_class = MiqPerformance::Configuration::REQUESTOR_CONFIG
        conf = conf_class.new nil, nil, nil, nil, nil, "tmp/miq_perf"
        MiqPerformance.config.instance_variable_set :@requestor, conf
      end

      it "returns 'tmp/miq_perf' as an aboslute path" do
        expect(described_class.send(:filepath)).to eq("#{pwd}/tmp/miq_perf")
      end

      it "gives preference to the requestfile_dir config" do
        MiqPerformance.config.instance_variable_set :@default_dir, '/my/path'

        expect(described_class.send(:filepath)).to eq("#{pwd}/tmp/miq_perf")
      end
    end

    context "with requestfile_dir set to an absolute path" do
      it "returns '/tmp/miq_perf' as defined" do
        conf_class = MiqPerformance::Configuration::REQUESTOR_CONFIG
        conf = conf_class.new nil, nil, nil, nil, nil, "/tmp/miq_perf"
        MiqPerformance.config.instance_variable_set :@requestor, conf

        expect(described_class.send(:filepath)).to eq("/tmp/miq_perf")
      end
    end
  end
end
