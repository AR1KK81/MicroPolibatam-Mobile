<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title>Kode OTP Pemulihan Kata Sandi</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F4F8FF; font-family: 'Segoe UI', Arial, sans-serif; color: #0F172A;">
    <table width="100%" cellpadding="0" cellspacing="0" style="padding: 32px 16px;">
        <tr>
            <td align="center">
                <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 480px; background-color: #FFFFFF; border-radius: 20px; border: 1px solid #E3ECFB; padding: 32px;">
                    <tr>
                        <td align="center" style="padding-bottom: 16px;">
                            <span style="display: inline-block; background-color: #CCFBF1; color: #059669; font-size: 11px; font-weight: 800; letter-spacing: 0.06em; padding: 5px 14px; border-radius: 999px; text-transform: uppercase;">
                                PORTAL ADMISI RESMI
                            </span>
                            <h1 style="margin: 14px 0 6px; font-size: 22px; font-weight: 800; color: #0F172A;">
                                Pemulihan Kata Sandi
                            </h1>
                            <p style="margin: 0; font-size: 13.5px; color: #64748B;">
                                Sistem PMB Microcredential Polibatam
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 14px; line-height: 1.6; color: #334155; padding-top: 8px;">
                            Halo <strong>{{ $recipientEmail }}</strong>,<br><br>
                            Kami menerima permintaan untuk mengatur ulang kata sandi akun Anda. Gunakan <strong>Kode OTP 6-digit</strong> berikut untuk melanjutkan:
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="padding: 24px 0;">
                            <div style="display: inline-block; background-color: #F3F8FF; border: 2px dashed #0052CC; border-radius: 16px; padding: 16px 32px; font-size: 32px; font-weight: 800; letter-spacing: 8px; color: #0052CC;">
                                {{ $otpCode }}
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 13px; line-height: 1.6; color: #64748B;">
                            Kode OTP ini hanya berlaku selama <strong>{{ $expiresInMinutes }} menit</strong>. Demi keamanan akun Anda, jangan berikan kode ini kepada siapa pun.
                        </td>
                    </tr>
                    <tr>
                        <td style="border-top: 1px solid #E2E8F0; margin-top: 24px; padding-top: 18px; font-size: 12px; color: #94A3B8; text-align: center;">
                            Jika Anda tidak merasa meminta pengaturan ulang kata sandi, abaikan email ini.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
