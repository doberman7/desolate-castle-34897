require 'openpay'
class MessagesController < ApplicationController

  def charges
    p "*" * 50
    p "charges"

    @openpay=OpenpayApi.new("mzdtln0bmtms6o3kck8f","sk_e568c42a6c384b7ab02cd47d2e407cab")
    @charges=@openpay.create(:charges)
    request_hash={
         "method" => "store",
         "amount" => params[:charges][:amount],
         "description" => "Cargo con tienda"
       }

    response_hash=@charges.create(request_hash.to_hash)
    p response_hash
    p "*" * 50
  end

  def openpay
    #p "_" * 50
    # #merchant and private key
    # merchant_id='mywvupjjs9xdnryxtplq'
    # private_key='sk_92b25d3baec149e6b428d81abfe37006'
    # #An openpay resource factory instance is created out of the OpenpayApi
    # openpay=OpenpayApi.new(merchant_id,private_key)
    # # The openpay factory instance is in charge to generate the required resources through a factory method (create)
    # p charges=openpay.create(:charges)
    #p "_" * 50
  end

  def index
    # p "-" * 50
    # p "index de mensajes"
    # p session[:user_id]
    @messages = Message.all
  end

  def create
    # p "create messages"
    # "message"=>{"title"=>"", "text"=>"", "tag"=>""},
    title = params[:message][:title]
    text = params[:message][:text]
    input_in_the_form = params[:message][:tag]
    autor = User.find(session[:user_id].to_i).name
    m = Message.create(title: title, text: text, autor: autor)
    if input_in_the_form != ""
      input_in_the_form.downcase!
			# separate the input throw a regex with comas, ignoring black spaces and put in a Ary
			ary_whit_input = input_in_the_form.split (/\s*,\s*/)
      ary_whit_input.uniq!
			# itarate throw the ary
			ary_whit_input.each do |tag_name|
				# find if the tag already exists
				tag = Tag.find_by(name: tag_name)
				# if not already exists
				if tag.blank?
					# create a new tag
					tag = Tag.create(name: tag_name)
          MessageTag.create(message_id: m.id, tag_id: tag.id)
        else
          MessageTag.create(message_id: m.id, tag_id: tag.id)
				end
			end
    end
    @messages= Message.all
    render 'messages/index'
  end

  def search
    p "_" * 50
    p "messages_search"
    @word = params[:search][:word]
    unless @word == ""
      @word.downcase!
    end
    @mtitle = Message.where(title: @word)
    @mtext = Message.where(text: @word)
    @mautor = Message.where(autor: @word)
    @tname = Tag.where(name: @word)

    p "_" * 50
  end

end
