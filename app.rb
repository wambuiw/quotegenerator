# app.rb - Main Sinatra application file
# This is the heart of our web app. It handles all routes (URLs) and logic.

# --- STEP 1: Load required libraries ---
require 'sinatra'       # The web framework
require 'json'          # For sending data back as JSON (used by our API routes)

# --- STEP 2: Define our motivational quotes ---
# An array is a list of items in Ruby. Each quote is a String (text in quotes).
QUOTES = [
  "The only way to do great work is to love what you do. – Steve Jobs",
  "In the middle of every difficulty lies opportunity. – Albert Einstein",
  "It does not matter how slowly you go as long as you do not stop. – Confucius",
  "Success is not final, failure is not fatal: It is the courage to continue that counts. – Churchill",
  "Believe you can and you're halfway there. – Theodore Roosevelt",
  "Your limitation—it's only your imagination.",
  "Push yourself, because no one else is going to do it for you.",
  "Great things never come from comfort zones.",
  "Dream it. Wish it. Do it.",
  "The harder you work for something, the greater you'll feel when you achieve it.",
  "Don't stop when you're tired. Stop when you're done.",
  "Wake up with determination. Go to bed with satisfaction.",
  "Little things make big days.",
  "It's going to be hard, but hard does not mean impossible.",
  "Don't wait for opportunity. Create it.",
  "Reduce the number of chairs on your table,friends are wicked and will stab you in the back,keep only the ones who really care about you. -Robert Burale" 
].freeze  # .freeze makes this array immutable (unchangeable) — a good habit

# --- STEP 3: Configure Sinatra ---
# Tell Sinatra where our views (HTML templates) and public (CSS/JS) files live
set :views,  File.join(File.dirname(__FILE__), 'views')
set :public_folder, File.join(File.dirname(__FILE__), 'public')

# The file where we'll save favourite quotes
QUOTES_FILE = File.join(File.dirname(__FILE__), 'quotes.txt')

# --- STEP 4: Define Routes ---
# A "route" is a URL path + what code to run when someone visits it.

# GET '/' — the homepage
# When someone visits http://localhost:4567 this runs first
get '/' do
  erb :index   # Render the file views/index.erb as HTML and send it to the browser
end

# GET '/random' — returns a random quote as JSON
# Our JavaScript will call this URL in the background (no page reload)
get '/random' do
  content_type :json   # Tell the browser we're sending JSON data

  quote = QUOTES.sample   # .sample picks ONE random element from the array

  # Return a JSON object with the quote and a success status
  { status: 'ok', quote: quote }.to_json
end

# POST '/save' — saves a quote to quotes.txt
# POST is used when we're SENDING data to the server (not just reading)
post '/save' do
  content_type :json

  # params[] is a Hash (key-value store) of data sent from the browser
  quote = params[:quote].to_s.strip   # .strip removes leading/trailing spaces

  # --- Input validation ---
  # If the quote is blank, return an error immediately
  if quote.empty?
    halt 400, { status: 'error', message: 'No quote provided to save.' }.to_json
  end

  # Make sure the quote actually exists in our list (prevents junk input)
  unless QUOTES.include?(quote)
    halt 400, { status: 'error', message: 'Invalid quote — please generate one first.' }.to_json
  end

  begin
    # File.open with 'a' flag = APPEND mode (adds to file without deleting old content)
    File.open(QUOTES_FILE, 'a') do |file|
      file.puts "[#{Time.now.strftime('%A, %d %B %Y at %I:%M:%S %p')}] #{quote}"
    end

    { status: 'ok', message: 'Quote saved successfully! 🎉' }.to_json

  rescue StandardError => e
    # If ANYTHING goes wrong writing the file, catch the error gracefully
    halt 500, { status: 'error', message: "Could not save: #{e.message}" }.to_json
  end
end

# GET '/saved' — returns all saved quotes from quotes.txt
get '/saved' do
  content_type :json

  # File.exist? returns true/false — check before reading
  unless File.exist?(QUOTES_FILE)
    return { status: 'ok', quotes: [], message: 'No quotes saved yet.' }.to_json
  end

  begin
    # File.readlines reads the file and returns an Array of lines
    # .map(&:chomp) removes the newline character (\n) from each line
    # .reject(&:empty?) removes any blank lines
    lines = File.readlines(QUOTES_FILE).map(&:chomp).reject(&:empty?)

    { status: 'ok', quotes: lines }.to_json

  rescue StandardError => e
    halt 500, { status: 'error', message: "Could not read file: #{e.message}" }.to_json
  end
end
