using System;
using System.IO;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.Web;
using System.Web.UI;
using System.Net.Mail;
using System.Threading;
using System.Collections;
using System.Collections.Generic;
using System.Web.Configuration;
using System.Security.Cryptography;
using System.Configuration;
using Quiksoft.FreeSMTP;

/// <summary>
/// This class contains common methods and properties used by all components
/// </summary>
public class Common
{
    public static string ConnectionString
    {
        get { return WebConfigurationManager.ConnectionStrings["db_connection"].ConnectionString; }
    }

    #region "Send Mail Methods"

    public static string MailServer
    {
        get
        {
            return GetSettings("MailServer");
        }
    }

    public static string MailStyle
    {
        get
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("<style>.mailbody{font-family:Tahoma;font-size:12px}");
            sb.AppendLine(".mailbody table{font-family:Tahoma;font-size:12px}");
            sb.AppendLine(".mailbody a{font-family:Tahoma;font-size:12px;font-weight:bold;text-decoration:none;color:#000000;}");
            sb.AppendLine(".mailbody a:hover{font-family:Tahoma;font-size:12px;font-weight:bold;text-decoration:underline;color:#000000;}");
            sb.AppendLine(".mailbody a.DO{font-family:Tahoma;font-size:12px;text-decoration:underline;color:#18A8D8;}");
            sb.AppendLine(".mailbody a.DO:hover{font-family:Tahoma;font-size:12px;text-decoration:none;color:#18A8D8;}</style>");
            return sb.ToString();
        }
    }

    //public static void SendMail(string Sender, string SenderName, string Recipient, string Subject, string Body, object[] attachments)
    //{
    //    EmailMessage mail = new EmailMessage();
    //    mail.From.Email = Sender;
    //    mail.From.Name = SenderName;
    //    mail.Recipients.Add(Recipient);
    //    mail.Subject = Subject;
    //    mail.BodyParts.Add(Body, BodyPartFormat.HTML);
    //    mail.CharsetEncoding = Encoding.UTF8;

    //    if (attachments != null)
    //    {
    //        foreach (object file in attachments)
    //            mail.Attachments.Add((Quiksoft.FreeSMTP.Attachment)file);
    //    }

    //    Thread mailThread = new Thread(new ParameterizedThreadStart(SendMailThread));
    //    mailThread.Start(mail);
    //}

    public static void SendMails(string Sender, string SenderName, string[] Recipients, string Subject, string Body)
    {
        List<EmailMessage> mails = new List<EmailMessage>();

        foreach (string Recipient in Recipients)
        {
            EmailMessage mail = new EmailMessage();

            mail.From.Email = Sender;
            mail.From.Name = SenderName;
            mail.Recipients.Add(Recipient);
            mail.Subject = Subject;
            mail.BodyParts.Add(Body, BodyPartFormat.HTML);
            mail.CharsetEncoding = Encoding.UTF8;
        }

        Thread mailThread = new Thread(new ParameterizedThreadStart(SendMailsThread));
        mailThread.Start(mails);
    }
    public static void SendMail(string Sender, string Recipient, string Subject, string Body, object attachments)
    {
        EmailMessage mail = new EmailMessage();
        mail.From.Email = Sender;
        mail.Recipients.Add(Recipient);
        mail.Subject = Subject;
        mail.BodyParts.Add(Body, BodyPartFormat.HTML);
        mail.CharsetEncoding = Encoding.UTF8;

        if (attachments != null)
        {
            mail.Attachments.Add((Quiksoft.FreeSMTP.Attachment)attachments);
        }

        Thread mailThread = new Thread(new ParameterizedThreadStart(SendMailThread));
        mailThread.Start(mail);
    }
    public static void SendMail(string Sender, string Recipient, string[] CCS, string Subject, string Body, object attachments)
    {
        EmailMessage mail = new EmailMessage();
        mail.From.Email = Sender;
        mail.Recipients.Add(Recipient);
        foreach (string cc in CCS)
        {
            mail.Recipients.Add(cc, "", RecipientType.CC);
        }
        mail.Subject = Subject;
        mail.BodyParts.Add(Body, BodyPartFormat.HTML);
        mail.CharsetEncoding = Encoding.UTF8;

        if (attachments != null)
        {
            mail.Attachments.Add((Quiksoft.FreeSMTP.Attachment)attachments);
        }

        Thread mailThread = new Thread(new ParameterizedThreadStart(SendMailThread));
        mailThread.Start(mail);
    }
    public static DataTable GetStudentRepeatTermsResults(int studentId, int semesterId)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("StudentTerms_Repeat_GetGrades", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@studentid", SqlDbType.Int).Value = studentId;
                command.Parameters.Add("@semesterId", SqlDbType.Int).Value = semesterId;

                DataTable dtGrades = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(dtGrades);

                return dtGrades;
            }
        }
    }

    public static DataTable GetStudentTotalResults(int studentId, int semesterId)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("StudentTerms_GetTotalGrade", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@studentid", SqlDbType.Int).Value = studentId;
                command.Parameters.Add("@semesterId", SqlDbType.Int).Value = semesterId;

                DataTable dtGrades = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(dtGrades);

                return dtGrades;
            }
        }
    }
    public static void SendMails(string Sender, string[] Recipients, string Subject, string Body)
    {
        List<EmailMessage> mails = new List<EmailMessage>();

        foreach (string Recipient in Recipients)
        {
            EmailMessage mail = new EmailMessage();

            mail.From.Email = Sender;
            mail.Recipients.Add(Recipient);
            mail.Subject = Subject;
            mail.BodyParts.Add(Body, BodyPartFormat.HTML);
            mail.CharsetEncoding = Encoding.UTF8;
        }

        Thread mailThread = new Thread(new ParameterizedThreadStart(SendMailsThread));
        mailThread.Start(mails);
    }

    private static void SendMailThread(object msg)
    {
        SMTP smtp = new SMTP(MailServer);

        try
        {
            smtp.Send((EmailMessage)msg);
        }
        catch { }
    }

    private static void SendMailsThread(object mails)
    {
        SMTP smtp = new SMTP(MailServer);

        List<EmailMessage> mailslist = mails as List<EmailMessage>;

        foreach (EmailMessage mail in mailslist)
        {
            try
            {
                smtp.Send((EmailMessage)mail);
            }
            catch { }
        }
    }

    #endregion

    public static void ShowError(Page pg, string msg)
    {
        ClientScriptManager csm = pg.ClientScript;
        if (!csm.IsStartupScriptRegistered(Type.GetType("System.String"), "error"))
            csm.RegisterStartupScript(Type.GetType("System.String"), "error", "alert('" + msg + "');", true);
    }

    public static string HashData1(string Data)
    {
        byte[] dataBytes = Encoding.UTF8.GetBytes(Data);
        SHA1 sha1Hash = SHA1.Create();
        byte[] dataHash = sha1Hash.ComputeHash(dataBytes);
        return Convert.ToBase64String(dataHash);
    }

    public static string HashData(string Data)
    {
        byte[] dataBytes = Encoding.UTF8.GetBytes(Data);
        SHA1 sha1Hash = SHA1.Create();
        byte[] dataHash = sha1Hash.ComputeHash(dataBytes);
        string dataNew = Convert.ToBase64String(dataHash);
        return System.Text.RegularExpressions.Regex.Replace(dataNew, "\\W", string.Empty);
    }

    public static string SetUniqueFilename(string path, string filename)
    {
        int sequence = 1;
        string newFilename = filename;

        while (File.Exists(path + newFilename))
        {
            newFilename = Path.GetFileNameWithoutExtension(path + filename) +
                sequence.ToString() + Path.GetExtension(path + filename);
            sequence++;
        }
        return newFilename;
    }

    #region "Image Resizing Methods"

    public static string ResizeImage(string path, string filename, int lnWidth, int lnHeight, bool overRight, bool keepRatio)
    {
        string newfilename = string.Empty;
        Bitmap srcbmp = new Bitmap(path + filename);

        if (srcbmp.Width > lnWidth || srcbmp.Height > lnHeight)
        {
            Bitmap bmpOut = null;

            decimal lnRatio;
            int lnNewWidth = 0;
            int lnNewHeight = 0;

            if (keepRatio)
            {
                if (srcbmp.Width > srcbmp.Height)
                {
                    lnRatio = (decimal)lnWidth / srcbmp.Width;
                    lnNewWidth = lnWidth;
                    decimal lnTemp = srcbmp.Height * lnRatio;
                    lnNewHeight = (int)lnTemp <= lnHeight ? (int)lnTemp : lnHeight;
                }
                else
                {
                    lnRatio = (decimal)lnHeight / srcbmp.Height;
                    lnNewHeight = lnHeight;
                    decimal lnTemp = srcbmp.Width * lnRatio;
                    lnNewWidth = (int)lnTemp <= lnWidth ? (int)lnTemp : lnWidth;
                }
            }
            else
            {
                lnNewWidth = lnWidth;
                lnNewHeight = lnHeight;
            }

            try
            {
                bmpOut = new Bitmap(lnNewWidth, lnNewHeight);
                Graphics g = Graphics.FromImage(bmpOut);
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.FillRectangle(Brushes.White, 0, 0, lnNewWidth, lnNewHeight);
                g.DrawImage(srcbmp, 0, 0, lnNewWidth, lnNewHeight);
                srcbmp.Dispose();

                EncoderParameters parameters = new EncoderParameters(1);
                System.Drawing.Imaging.Encoder enc = System.Drawing.Imaging.Encoder.Quality;
                parameters.Param[0] = new EncoderParameter(enc, 100L);
                ImageCodecInfo imageCodecInfo = GetEncoderInfo("image/jpeg");

                if (!overRight)
                    newfilename = Path.GetFileNameWithoutExtension(path + filename) + "_lg.jpg";
                else
                    newfilename = filename;

                bmpOut.Save(path + newfilename, imageCodecInfo, parameters);
                bmpOut.Dispose();
            }
            catch
            {
                srcbmp.Dispose();
            }
        }
        srcbmp.Dispose();
        return newfilename;
    }

    public static string CreateThumbnail(string path, string filename, int width, int height)
    {
        Bitmap srcbmp = new Bitmap(path + filename);
        Image outimg = srcbmp.GetThumbnailImage(width, height, null, IntPtr.Zero);

        EncoderParameters parameters = new EncoderParameters(1);
        System.Drawing.Imaging.Encoder enc = System.Drawing.Imaging.Encoder.Quality;
        parameters.Param[0] = new EncoderParameter(enc, 100L);
        ImageCodecInfo imageCodecInfo = GetEncoderInfo("image/jpeg");

        string thumbname = Path.GetFileNameWithoutExtension(path + filename) + "_th.jpg";
        //thumbname = SetUniqueFilename(path, thumbname);
        outimg.Save(path + thumbname, imageCodecInfo, parameters);

        srcbmp.Dispose();
        outimg.Dispose();

        return thumbname;
    }

    public static ImageCodecInfo GetEncoderInfo(String mimeType)
    {
        ImageCodecInfo Result = null;
        ImageCodecInfo[] Encoders = ImageCodecInfo.GetImageEncoders();
        for (int i = 0; Result == null && i < Encoders.Length; i++)
        {
            if (Encoders[i].MimeType == mimeType)
            {
                Result = Encoders[i];
            }
        }
        return Result;
    }

    #endregion

    #region "Application Settings Methods"

    public static Hashtable GetSettings(byte TypeId)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("AppSettings_Get", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@TypeId", SqlDbType.TinyInt).Value = TypeId;

                Hashtable values = new Hashtable();
                connection.Open();
                SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);

                if (reader.HasRows)
                {
                    while (reader.Read())
                        values.Add(reader[0].ToString(), reader[1].ToString());
                }

                reader.Close();
                return values;
            }
        }
    }

    public static string GetSettings(string Key)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("AppSettings_Get", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Key", SqlDbType.VarChar, 50).Value = Key;

                object value = null;
                connection.Open();
                value = command.ExecuteScalar();
                connection.Close();

                return value.ToString();
            }
        }
    }

    public static void UpdateSettings(DataTable dtSettings)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("AppSettings_Update", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Key", SqlDbType.VarChar, 50, "Key");
                command.Parameters.Add("@Value", SqlDbType.NVarChar, 1500, "Value");

                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.InsertCommand = command;
                adapter.Update(dtSettings);
            }
        }
    }

    public static void UpdateSettings(string Key, string Value)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("AppSettings_Update", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Key", SqlDbType.VarChar, 50).Value = Key;
                command.Parameters.Add("@Value", SqlDbType.NVarChar, 1500).Value = TeiLib.Utils.DefaultToDBNull(Value, DbType.String);

                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
            }
        }
    }

    public static string CalculateMD5Hash(string input)
    {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] bytes = Encoding.UTF8.GetBytes(input);
        bytes = md5.ComputeHash(bytes);
        StringBuilder s = new StringBuilder();
        foreach (byte b in bytes)
        {
            s.Append(b.ToString("x2").ToLower());
        }
        string result = s.ToString().ToUpper();
        return result;
    }

    #endregion

    public static bool DeleteFileFromDisk(string filepath)
    {
        bool result = true;
        try
        {
            if (File.Exists(filepath))
                File.Delete(filepath);
        }
        catch
        {
            result = false;
        }
        return result;
    }
    public static void HideRows(DataTable Table, string Tablename, string IDColumn)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            string sds = Table.Rows[0]["ID"].ToString();
            SqlCommand command = connection.CreateCommand();
            command.CommandText = "HideRow";
            command.Parameters.Add("@Tablename", SqlDbType.VarChar).Value = Tablename;
            command.Parameters.Add("@IDColumn", SqlDbType.VarChar).Value = IDColumn;
            command.Parameters.Add("@IDValue", SqlDbType.Int, 4, "ID");
            command.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.InsertCommand = command;
            adapter.Update(Table);
        }
    }

    
    public static DataTable GetStudentTermsResults(int studentId , int semesterId)
    {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("StudentTerms_GetGrades", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@studentid", SqlDbType.Int).Value = studentId;
                command.Parameters.Add("@semesterId", SqlDbType.Int).Value = semesterId; 

                DataTable dtGrades = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(dtGrades);

                return dtGrades;
            }
        }
    }
    public static void WriteContentToFile(String filename, String content)
    {
        object obj = new object();
        lock (obj)
        {
            FileStream fs = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
            StreamWriter writer = new StreamWriter(fs, System.Text.Encoding.UTF8);
            try
            {
                writer.Write(content);
            }
            catch (Exception)
            {
            }
            finally
            {
                writer.Flush();
                writer.Close();
                fs.Close();
            }
        }
    }

}
