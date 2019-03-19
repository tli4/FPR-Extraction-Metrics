RSpec.describe PicaReportImporter do

  let(:mock_file) { File.new(Rails.root.join('spec', 'test_files', 'StatisticsReport.xlsx')) }

  describe "#evaluation_hashes" do
    it "doesn't have nil attributes anywhere" do
      hashes = PicaReportImporter.new(mock_file, 'StatisticsReport.xlsx').send(:evaluation_hashes)
      hashes.each do |hash|
        hash.each do |k, v|
          expect(v).not_to be(nil)
        end
      end
    end

    it "should have read in 9 entries" do
      hashes = PicaReportImporter.new(mock_file, 'StatisticsReport.xlsx').send(:evaluation_hashes)
      expect(hashes.size).to be(9)
    end

    it "each entry should contain 15 columns" do
      hashes = PicaReportImporter.new(mock_file, 'StatisticsReport.xlsx').send(:evaluation_hashes)
      hashes.each do |hash|
        expect(hash.size).to be(15)
      end
    end
  end
end
