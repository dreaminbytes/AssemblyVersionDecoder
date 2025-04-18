<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" data-bs-theme="dark">

<head>
    <meta charset="utf-8">
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Assembly Version Decoder" />
    <title>Assembly Version Decoder</title>

    <!-- Bootstrap CSS and Bootstrap JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
        </script>
    
    <style>
        .bi {
            vertical-align: -.125em;
            fill: currentColor;
        }
    </style>
</head>

<body>
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="decodeIcon" viewBox="0 0 16 16">
            <title>Bootstrap</title>
            <path d="M10.478 1.647a.5.5 0 1 0-.956-.294l-4 13a.5.5 0 0 0 .956.294zM4.854 4.146a.5.5 0 0 1 0 .708L1.707 8l3.147 3.146a.5.5 0 0 1-.708.708l-3.5-3.5a.5.5 0 0 1 0-.708l3.5-3.5a.5.5 0 0 1 .708 0m6.292 0a.5.5 0 0 0 0 .708L14.293 8l-3.147 3.146a.5.5 0 0 0 .708.708l3.5-3.5a.5.5 0 0 0 0-.708l-3.5-3.5a.5.5 0 0 0-.708 0"/>
        </symbol>
        <symbol id="arrow-right-short" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8z" />
        </symbol>
    </svg>

    <div class="container my-3 my-sm-5">
        <div class="p-2 p-sm-5 text-center bg-body-tertiary rounded-3">
            <svg class="bi mt-2 mt-md-4 mb-1 mb-md-3" style="color: var(--bs-indigo);" width="100" height="100">
                <use xlink:href="#decodeIcon" />
            </svg>

            <h1 class="text-body-emphasis">Assembly Version Decoder</h1>
            <p class="col-lg-8 mx-auto fs-5 text-muted">
                This is a simple ASPX webpage to help decode Microsofts Assembly Version build numbers.
                <code>Example: 1.0.5876.25143</code>
            </p>

            <h3 class="text-body-emphasis">Usage:</h3>
            <p class="col-lg-8 mx-auto fs-5 text-muted">
                Input the assembly version as Major.Minor.Release.Build and click decode.
            </p>

            <div class="d-inline-flex gap-2 mb-5">
                <form id="form1" runat="server">
                    <div class="mb-3">
                        <label id="assemblyLabel" class="form-label px-2" for="assemblyTextBox">
                            Assembly Version:
                        </label>
                        <asp:TextBox ID="AssemblyTextBox" runat="server" class="form" placeholder="1.0.5876.25143" required></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <button id="decodeButton" type="submit" class=" btn btn-primary btn-lg px-4 rounded-pill">
                            Decode
                        </button>
                    </div>

                    <asp:Label ID="OutputLabel" runat="server" Text=""></asp:Label>
                    <br />
                    <asp:Label ID="ErrorMessage" runat="server" Text="" class="text-danger"></asp:Label>
                </form>
            </div>
        </div>
    </div>
</body>

</html>

<script runat="server" lang="C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            // Code to run when the page is first loaded (not on postbacks)
        }
        else 
        {
            OutputLabel.Text = ""; // reset output text
            ErrorMessage.Text = ""; // reset error message

            var input = AssemblyTextBox.Text.Trim();

            if (string.IsNullOrWhiteSpace(input))
            {
                ErrorMessage.Text = "Empty version string. <br/>Expected Major.Minor.Build.Revision";
                return;
            }

            Version version;
            if (!Version.TryParse(input, out version))
            {
                ErrorMessage.Text = "Invalid version string format. <br/>Expected Major.Minor.Build.Revision";
                return;
            }

            if (version.Build < 0 || version.Revision < 0)
            {
                ErrorMessage.Text = "Invalid version string format. Build and Revision must be positive numbers";
                return;
            }

            // Calculate assembly date
            var date = new DateTime(2000, 1, 1)     // baseline is 01/01/2000
                .AddDays(version.Build)             // build is number of days after baseline
                .AddSeconds(version.Revision * 2);  // revision is half the number of seconds into the day

            var nl = "<br/>";
            var outputText = String.Format("Major   : {0}", version.Major) + nl
                + String.Format("Minor   : {0}", version.Minor) + nl
                + String.Format("Build   : {0} = {1}", version.Build, date.ToShortDateString()) + nl
                + String.Format("Revision: {0} = {1}", version.Revision, date.ToLongTimeString());

            OutputLabel.Text = outputText;
        }
    }
</script>