# ✦ Daily Spark — Sinatra Quote Generator
### A beginner Ruby web app built with Sinatra

---

## 📁 Project Structure

```
quotegenerator/
│
├── app.rb              ← Main Ruby/Sinatra application (all routes live here)
├── quotes.txt          ← Saved quotes are written here automatically
├── views/
│   └── index.erb       ← HTML template (ERB = Embedded Ruby)
├── public/
│   └── style.css       ← All styling
└── README.md           ← You are here
```

---

## 🛠️ Step-by-Step Setup (Windows + VS Code)

### Step 1 — Install Ruby

1. Go to https://rubyinstaller.org/downloads/
2. Download **Ruby+Devkit 3.x.x (x64)** — pick the one with *(recommended)* label
3. Run the installer → tick **"Add Ruby to PATH"** → click Install
4. When prompted, press **Enter** to install MSYS2/MINGW toolchain (required for gems)
5. Open a **new** Command Prompt and verify:
   ```
   ruby --version
   gem --version
   ```

### Step 2 — Install Sinatra

Open a terminal (VS Code → `Ctrl+`` ` ) and run:

```bash
gem install sinatra
gem install rerun      # Optional but useful: auto-restarts server on file save
```

Verify: `gem list sinatra` should show `sinatra (x.x.x)`

### Step 3 — Create the project folder

```bash
mkdir quotegenerator
cd quotegenerator
mkdir views
mkdir public
```

### Step 4 — Create the files

Copy the provided files into each location:
- `app.rb` → root of quotegenerator/
- `views/index.erb` → into the views/ folder
- `public/style.css` → into the public/ folder
- `quotes.txt` → root of quotegenerator/ (can be empty)

### Step 5 — Run the app

```bash
# Standard way:
ruby app.rb

# With auto-reload (saves you restarting manually on every change):
rerun app.rb
```

You should see:
```
== Sinatra (v3.x.x) has taken the stage on 4567 for development...
Use Ctrl-C to stop
```

### Step 6 — Open in browser

Go to: **http://localhost:4567**

---

## 🌐 How the Routes Work

| Method | URL       | What it does                          |
|--------|-----------|---------------------------------------|
| GET    | `/`       | Shows the homepage (index.erb)        |
| GET    | `/random` | Returns a random quote as JSON        |
| POST   | `/save`   | Saves a quote to quotes.txt           |
| GET    | `/saved`  | Returns all saved quotes as JSON      |

> **Key concept**: GET = *reading* data. POST = *sending/writing* data.

---

## 🐛 Common Beginner Errors & Fixes

### ❌ `cannot load such file -- sinatra (LoadError)`
**Cause:** Sinatra gem isn't installed.
**Fix:** Run `gem install sinatra` then try again.

---

### ❌ `Address already in use - bind(2) for 0.0.0.0 port 4567`
**Cause:** Another instance of the app is already running.
**Fix:** Press `Ctrl+C` in the existing terminal, or close it, then re-run `ruby app.rb`.

---

### ❌ Browser shows `This site can't be reached`
**Cause:** The app isn't running, or you mistyped the URL.
**Fix:** Check that the terminal shows *"Sinatra has taken the stage"*. Use `http://localhost:4567` (not https://).

---

### ❌ `No such file or directory @ rb_sysopen - quotes.txt`
**Cause:** quotes.txt doesn't exist yet.
**Fix:** Create an empty `quotes.txt` file in the project root. The app will append to it.

---

### ❌ Saved quotes show `Invalid quote — please generate one first.`
**Cause:** The save button was clicked with a manually typed/edited quote (or blank).
**Fix:** This is intentional input validation! Click "Generate Quote" first, then "Save Quote".

---

### ❌ Changes to style.css or index.erb don't update in browser
**Fix:** Do a hard refresh: `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac).

---

## 💡 Ruby Concepts Used in This App

| Concept        | Where                            | What it does                          |
|----------------|----------------------------------|---------------------------------------|
| `Array`        | `QUOTES = [...]`                 | Stores a list of quotes               |
| `.sample`      | `QUOTES.sample`                  | Picks a random element                |
| `.freeze`      | `QUOTES.freeze`                  | Prevents accidental changes           |
| `Hash / JSON`  | `{ status: 'ok' }.to_json`       | Sends structured data to the browser  |
| `File.open`    | Save route                       | Writes text to a file                 |
| `File.readlines` | Saved route                    | Reads all lines from a file           |
| `begin/rescue` | Save & read routes               | Catches errors gracefully             |
| `params[]`     | POST /save                       | Reads data sent from the browser form |
| `halt`         | Input validation                 | Stops processing and returns an error |
| `erb :index`   | GET /                            | Renders the HTML template             |

---

## 🔭 Ideas to Extend This App (Next Steps)

- **Categories**: Group quotes by topic (motivation, focus, courage) and let users filter
- **Duplicate detection**: Before saving, check if the quote is already in quotes.txt
- **Delete saved quotes**: Add a route DELETE /saved/:id
- **Quote counter**: Track how many times each quote was generated
- **Sinatra Sessions**: Add real login/logout with `enable :sessions`
- **Database**: Replace quotes.txt with SQLite using the `sequel` gem

---

## 📚 Learning Resources

- Sinatra docs: http://sinatrarb.com/intro.html
- Ruby in 20 minutes: https://www.ruby-lang.org/en/documentation/quickstart/
- ERB templating: https://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html
