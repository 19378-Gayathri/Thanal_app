from flask import Flask, render_template, request

app = Flask(__name__)
USER_FILE = "users.txt"

@app.route("/")
def main_page():
    return render_template("loginscreen.dart")

@app.route("/register")
def register():
    return render_template("registerscreen.dart")

@app.route("/createaccount", methods=['POST'])
def create_db():
    username = request.form.get("username")
    password = request.form.get("password")
    mailid = request.form.get("mailid")

    with open(USER_FILE, "a") as f:
        f.write(f"{username},{password},{mailid}\n")

    return "Your account has been successfully created!"

@app.route("/login", methods=['POST'])
def login():
    username = request.form.get("username")
    password = request.form.get("password")
    flag = False

    try:
        with open(USER_FILE, "r") as f:
            for line in f:
                u, p, _ = line.strip().split(",")
                if u == username and p == password:
                    flag = True
                    break
    except FileNotFoundError:
        return "No users registered yet!"

    if flag:
        return "Login successful!"
    else:
        return "Login failed."

if __name__ == "__main__":
    app.run(debug=True)
