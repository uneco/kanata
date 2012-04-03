# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Kanata::Client do
  before do
    @appid  = ENV['YAHOO_DEVELOPER_NETWORK_APPID']
    @kanata = Kanata::Client.new(@appid)
  end

  describe :class do
    it do
      @kanata.should be_a Kanata::Client
    end
    it do
      @kanata.app_id.should === @appid
    end
  end

  describe :parse do
    context 'not given text' do
      it do
        lambda {
          @kanata.parse
        }.should raise_error(ArgumentError)
      end
    end

    context 'text given (default parse)' do
      before do
        @words = @kanata.parse("うー猫いんざおうちなうよー")
      end
      it do
        @words[0].should be_a Kanata::Word
      end
      it do
        @words.map(&:reading).join.should === 'うーねこいんざおうちなうよー'
      end
      it do
        @words.map(&:baseform).join.should === 'うー猫いるざおうちだうよー'
      end
      it do
        @words.map(&:surface).join.should === 'うー猫いんざおうちなうよー'
      end
    end

    context 'text given (filtered parse)' do
      before do
        @words = @kanata.parse("うー猫いんざおうちなうよー", filter:[9, 3])
      end
      it do
        @words.map(&:reading).join.should === 'うーねこうち'
      end
      it do
        @words.map(&:baseform).join.should === 'うー猫うち'
      end
      it do
        @words.map(&:surface).join.should === 'うー猫うち'
      end
    end

    context 'text given (reading only)' do
      before do
        @words = @kanata.parse("うー猫いんざおうちなうよー", response:[:reading])
      end
      it do
        @words.map(&:reading).join.should === 'うーねこいんざおうちなうよー'
      end
      it do
        @words.map(&:baseform).join.should === ''
      end
      it do
        @words.map(&:surface).join.should === ''
      end
    end
  end
end
