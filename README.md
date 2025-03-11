# For-labs#20
using System;
using System.Drawing;
using System.Windows.Forms;

namespace BlankScreenSaver
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            // Настройки формы
            this.BackColor = Color.Black;  // Черный фон
            this.FormBorderStyle = FormBorderStyle.None; // Убираем границы
            this.WindowState = FormWindowState.Maximized; // Во весь экран
            this.Cursor = Cursors.None; // Скрываем курсор
        }

        private void MainForm_MouseMove(object sender, MouseEventArgs e)
        {
            Application.Exit(); // Закрываем при движении мыши
        }

        private void MainForm_KeyDown(object sender, KeyEventArgs e)
        {
            Application.Exit(); // Закрываем при нажатии клавиши
        }
    }
}
