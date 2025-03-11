using System;
using System.Drawing;
using System.Windows.Forms;

namespace BlankScreenSaver
{
    public partial class Form1 : Form  // Обратите внимание: class Form1 (а не MainForm)
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.BackColor = Color.Black;
            this.FormBorderStyle = FormBorderStyle.None;
            this.WindowState = FormWindowState.Maximized;
            this.Cursor = Cursors.None;
        }

        private void Form1_MouseMove(object sender, MouseEventArgs e)
        {
            Application.Exit();
        }

        private void Form1_KeyDown(object sender, KeyEventArgs e)
        {
            Application.Exit();
        }
    }
}


####
namespace BlankScreenSaver
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.SuspendLayout();
            //
            // Form1
            //
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Form1"; // Важно: Name="Form1"
            this.Text = "Form1";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.Form1_Load);  // Form1_Load
            this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseMove); // Form1_MouseMove
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.Form1_KeyDown);   // Form1_KeyDown
            this.ResumeLayout(false);
        }

        #endregion
    }
}
