class FacebookSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  def remove_duplicate_uids(payload)
    puts "Removing duplicate_uids..."
    payload['entry'].each_with_object({}) do |entry, hash|
      hash[entry['uid']] ||= [] << entry
    end.values.collect { |update_payloads| update_payloads.min { |entry1, entry2| entry1['time']<=>entry2['time'] } }
  end
end
