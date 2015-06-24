class FacebookSubscription < ActiveRecord::Base
  belongs_to :user

  def remove_duplicate_uids(payload)
    payload['entry'].each_with_object({}) do |entry, hash|
      hash[entry['uid']] ||= [] << entry
    end.values.collect { |update_payloads| update_payloads.min { |entry1, entry2| entry1['time']<=>entry2['time'] } }
  end
end
