use Mix.Config

config :core, :email, %{
  styles: %{
    background: %{
      color: "#222222",
    },
    body: %{
      font_family: "sans-serif",
      font_size: "15px",
      line_height: "20px",
      text_color: "#555555",
    },
    button: %{
      border_radius: "4px",
      border: "1px solid #000000",
      background: "#222222",
      color: "#ffffff",
      font_family: "sans-serif",
      font_size: "15px",
      line_height: "15px",
      text_decoration: "none",
      padding: "13px 17px",
      display: "block",
    },
    column: %{
      background: "#FFFFFF",
      padding: "0 10px 40px 10px",
    },
    footer: %{
      padding: "20px",
      font_family: "sans-serif",
      font_size: "12px",
      line_height: "15px",
      text_align: "center",
      color: "#ffffff",
    },
    global: %{
      width: 600,
    },
    h1: %{
      margin: "0 0 10px 0",
      font_family: "sans-serif",
      font_size: "25px",
      line_height: "30px",
      color: "#333333",
      font_weight: "normal",
    },
    h2: %{
      margin: "0 0 10px 0",
      font_family: "sans-serif",
      font_size: "18px",
      line_height: "22px",
      color: "#333333",
      font_weight: "bold",
    },
    header: %{
      padding: "20px 0",
      text_align: "center",
    },
    hero_image: %{
      background: "#dddddd",
      display: "block",
      margin: "auto",
    },
    inner_column: %{
      padding: "10px 10px 0",
    },
    li: %{
      margin: "0 0 0 10px",
    },
    last_li: %{
      margin: "0 0 10px 30px",
    },
    spacer: %{
      height: "40",
      font_size: "0px",
      line_height: "0px",
    },
    ul: %{
      margin: "0 0 10px 0",
      padding: "0",
    },
  }
}
