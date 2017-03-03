RSpec.describe InterpretDate do
  include InterpretDate

  describe "#interpret_date" do
    let(:test_date) { Date.new(1990, 2, 6) }

    {
      "mmddyy" => "020690",
      "m/d/yy" => "2/6/90",
      "m/d/yyyy" => "2/6/1990",
      "mm/dd/yy" => "02/06/90",
      "mm/dd/yyyy" => "02/06/1990",
      "m-d-yy" => "2-6-90",
      "m-d-yyyy" => "2-6-1990",
      "mm-dd-yy" => "02-06-90",
      "mm-dd-yyyy" => "02-06-1990",
      "m.d.yy" => "2.6.90",
      "m.d.yyyy" => "2.6.1990",
      "mm.dd.yy" => "02.06.90",
      "mm.dd.yyyy" => "02.06.1990",
    }.each do |format, value|
      it "interprets dates in the form of #{format} properly" do
        expect(interpret_date(value)).to eq(test_date)
      end
    end

    context "with two digit year" do
      it "interprets the years based on the century break + default 10 year buffer" do
        buffer = 10
        century_break = (Date.today.year + buffer).to_s[2..3].to_i
        expect(interpret_date("01/01/#{century_break}")).to eq(Date.new(2000 + century_break, 1, 1))
        century_break += 1
        expect(interpret_date("01/01/#{century_break}")).to eq(Date.new(1900 + century_break, 1, 1))
      end

      it "interprets the years based on the century break + assigned buffer" do
        buffer = 1
        century_break = (Date.today.year + buffer).to_s[2..3].to_i
        expect(interpret_date("01/01/#{century_break}", buffer)).to eq(Date.new(2000 + century_break, 1, 1))
        century_break += 1
        expect(interpret_date("01/01/#{century_break}", buffer)).to eq(Date.new(1900 + century_break, 1, 1))
      end
    end

    it "returns the date if passed a Time object" do
      expect(interpret_date(Time.now)).to eq(Date.today)
    end

    it "returns the date if passed a Date object" do
      expect(interpret_date(Date.today)).to eq(Date.today)
    end

    it "returns nil if the input passed in cannot be parsed into a date" do
      expect(interpret_date("Kevin Bacon")).to eq(nil)
    end

    context "when the date is a db formatted string" do
      it "interprets the string as a date" do
        expect(interpret_date("2017-01-01")).to eql(Date.new(2017, 01, 01))
      end
    end
  end

  describe "#interpret_dob_date" do
    context "with two digit year" do
      it "interprets the years based on the century break" do
        century_break = (Date.today.year).to_s[2..3].to_i
        # Person with dob of 01/01/15 would yield 01/01/2015
        expect(interpret_dob_date("01/01/#{century_break}")).to eq(Date.new(2000 + century_break, 1, 1))
        century_break += 1
        # Person with dob of 01/01/16 would yield 01/01/1916 since 2016 hasn't occured yet.
        expect(interpret_dob_date("01/01/#{century_break}")).to eq(Date.new(1900 + century_break, 1, 1))
      end
    end
  end
end
