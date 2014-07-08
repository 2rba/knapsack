describe Knapsack::Distributors::ReportDistributor do
  let(:args) { {} }
  let(:default_report) { { 'default_report_spec.rb' => 1.0 } }

  let(:distributor) { described_class.new(args) }

  before do
    allow(Knapsack).to receive(:report) {
      instance_double(Knapsack::Report, open: default_report)
    }
  end

  describe '#sorted_report' do
    subject { distributor.sorted_report }

    let(:report) do
      {
        'e_spec.rb' => 3.0,
        'f_spec.rb' => 3.5,
        'c_spec.rb' => 2.0,
        'd_spec.rb' => 2.5,
        'a_spec.rb' => 1.0,
        'b_spec.rb' => 1.5,
      }
    end
    let(:args) { { report: report } }

    it do
      should eql([
        ["f_spec.rb", 3.5],
        ["e_spec.rb", 3.0],
        ["d_spec.rb", 2.5],
        ["c_spec.rb", 2.0],
        ["b_spec.rb", 1.5],
        ["a_spec.rb", 1.0],
      ])
    end
  end

  context do
    let(:report) do
      {
        'a_spec.rb' => 3.0,
        'b_spec.rb' => 1.0,
        'c_spec.rb' => 1.5,
      }
    end
    let(:args) { { report: report } }

    describe '#total_time_execution' do
      subject { distributor.total_time_execution }

      context 'when time is float' do
        it { should eql 5.5 }
      end

      context 'when time is not float' do
        let(:report) do
          {
            'a_spec.rb' => 3,
            'b_spec.rb' => 1,
          }
        end

        it { should eql 4.0 }
      end
    end

    describe '#node_time_execution' do
      subject { distributor.node_time_execution }
      let(:args) { { report: report, ci_node_total: 4 } }
      it { should eql 1.375 }
    end
  end

  context do
    let(:report) do
      {
        'g_spec.rb' => 9.0,
        'h_spec.rb' => 3.0,
        'i_spec.rb' => 3.0,
        'f_spec.rb' => 3.5,
        'c_spec.rb' => 2.0,
        'd_spec.rb' => 2.5,
        'a_spec.rb' => 1.0,
        'b_spec.rb' => 1.5,
      }
    end
    let(:ci_node_index) { nil }
    let(:args) do
      {
        report: report,
        ci_node_total: 3,
        ci_node_index: ci_node_index
      }
    end

    describe '#assign_spec_files_to_node' do
      before { distributor.assign_spec_files_to_node }

      it do
        expect(distributor.node_specs[0]).to eql({
          :node_index => 0,
          :time_left => -0.5,
          :spec_files_with_time => [
            ["g_spec.rb", 9.0]
          ]
        })
      end

      it do
        expect(distributor.node_specs[1]).to eql({
          :node_index => 1,
          :time_left => 0.0,
          :spec_files_with_time => [
            ["f_spec.rb", 3.5],
            ["d_spec.rb", 2.5],
            ["a_spec.rb", 1.0],
            ["b_spec.rb", 1.5]
          ]
        })
      end

      it do
        expect(distributor.node_specs[2]).to eql({
          :node_index => 2,
          :time_left => 0.5,
          :spec_files_with_time => [
            ["h_spec.rb", 3.0],
            ["c_spec.rb", 2.0],
            ["i_spec.rb", 3.0]
          ]
        })
      end
    end

    describe '#specs_for_node' do
      context 'when node exists' do
        it do
          expect(distributor.specs_for_node(1)).to eql([
            'f_spec.rb',
            'd_spec.rb',
            'a_spec.rb',
            'b_spec.rb'
          ])
        end
      end

      context "when node doesn't exist" do
        it { expect(distributor.specs_for_node(42)).to be_nil }
      end
    end
  end
end
