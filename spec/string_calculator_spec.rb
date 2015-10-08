require 'string_calculator'
describe StringCalculator do
  describe '.add' do 
    context 'given an empty string' do 
      it 'returns zero' do 
        expect(StringCalculator.add("")).to eql(0)
      end
    end
  end
end