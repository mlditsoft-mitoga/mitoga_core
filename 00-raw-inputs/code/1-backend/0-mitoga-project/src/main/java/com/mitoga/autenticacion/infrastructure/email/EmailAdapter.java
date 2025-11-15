package com.mitoga.autenticacion.infrastructure.email;

import com.mitoga.autenticacion.application.port.output.EmailPort;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

/**
 * EmailAdapter - Implementación del port EmailPort usando JavaMailSender
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - EMAIL ADAPTER
 * - Implementa EmailPort del dominio
 * - Usa JavaMailSender (Spring Boot Starter Mail)
 * - Envíos asíncronos (@Async) para no bloquear operaciones
 * - Templates HTML para emails profesionales
 */
@Component
public class EmailAdapter implements EmailPort {

    private static final Logger logger = LoggerFactory.getLogger(EmailAdapter.class);
    private static final String FROM_EMAIL = "noreply@mitoga.com";
    private static final String FROM_NAME = "MI-TOGA Plataforma de Tutorías";

    private final JavaMailSender javaMailSender;

    public EmailAdapter(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    @Async
    @Override
    public void enviarEmailVerificacion(String destinatario, String nombreCompleto, String codigoVerificacion) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(FROM_EMAIL, FROM_NAME);
            helper.setTo(destinatario);
            helper.setSubject("Verifica tu cuenta en MI-TOGA 🎓");

            String htmlContent = buildVerificationEmailHtml(nombreCompleto, codigoVerificacion);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            logger.info("Email de verificación enviado a: {}", destinatario);

        } catch (MessagingException e) {
            logger.error("Error al enviar email de verificación a {}: {}", destinatario, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado al enviar email: {}", e.getMessage());
        }
    }

    @Async
    @Override
    public void enviarEmailBienvenida(String destinatario, String nombreCompleto) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(FROM_EMAIL, FROM_NAME);
            helper.setTo(destinatario);
            helper.setSubject("¡Bienvenido a MI-TOGA! 🎉");

            String htmlContent = buildWelcomeEmailHtml(nombreCompleto);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            logger.info("Email de bienvenida enviado a: {}", destinatario);

        } catch (MessagingException e) {
            logger.error("Error al enviar email de bienvenida a {}: {}", destinatario, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado al enviar email: {}", e.getMessage());
        }
    }

    @Async
    @Override
    public void enviarEmailRecuperacionPassword(String destinatario, String nombreCompleto, String codigoRecuperacion) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(FROM_EMAIL, FROM_NAME);
            helper.setTo(destinatario);
            helper.setSubject("Recuperación de contraseña - MI-TOGA 🔐");

            String htmlContent = buildPasswordRecoveryEmailHtml(nombreCompleto, codigoRecuperacion);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            logger.info("Email de recuperación enviado a: {}", destinatario);

        } catch (MessagingException e) {
            logger.error("Error al enviar email de recuperación a {}: {}", destinatario, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado al enviar email: {}", e.getMessage());
        }
    }

    @Async
    @Override
    public void enviarEmailCambioPassword(String destinatario, String nombreCompleto) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(FROM_EMAIL, FROM_NAME);
            helper.setTo(destinatario);
            helper.setSubject("Contraseña cambiada exitosamente - MI-TOGA ✅");

            String htmlContent = buildPasswordChangedEmailHtml(nombreCompleto);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            logger.info("Email de cambio de contraseña enviado a: {}", destinatario);

        } catch (MessagingException e) {
            logger.error("Error al enviar email de cambio de contraseña a {}: {}", destinatario, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado al enviar email: {}", e.getMessage());
        }
    }

    @Async
    @Override
    public void enviarEmailNuevaSesion(String destinatario, String nombre, String dispositivo, String ipAddress) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(FROM_EMAIL, FROM_NAME);
            helper.setTo(destinatario);
            helper.setSubject("Nueva sesión detectada - MI-TOGA 🔐");

            String htmlContent = buildNewSessionEmailHtml(nombre, dispositivo, ipAddress);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            logger.info("Email de nueva sesión enviado a: {}", destinatario);

        } catch (MessagingException e) {
            logger.error("Error al enviar email de nueva sesión a {}: {}", destinatario, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado al enviar email: {}", e.getMessage());
        }
    }

    // ==================== TEMPLATES HTML ====================

    private String buildVerificationEmailHtml(String nombreCompleto, String codigo) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { text-align: center; margin-bottom: 30px; }
                        .logo { font-size: 32px; font-weight: bold; color: #4A90E2; }
                        .code-box { background-color: #f0f0f0; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0; border-radius: 5px; }
                        .footer { margin-top: 30px; text-align: center; color: #888; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <div class="logo">🎓 MI-TOGA</div>
                        </div>
                        <h2>Hola, %s!</h2>
                        <p>Gracias por registrarte en MI-TOGA. Para completar tu registro, por favor verifica tu dirección de correo electrónico usando el siguiente código:</p>
                        <div class="code-box">%s</div>
                        <p>Este código es válido por <strong>5 minutos</strong>.</p>
                        <p>Si no solicitaste este registro, puedes ignorar este correo.</p>
                        <div class="footer">
                            <p>© 2025 MI-TOGA - Plataforma de Tutorías en Línea</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nombreCompleto, codigo);
    }

    private String buildWelcomeEmailHtml(String nombreCompleto) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { text-align: center; margin-bottom: 30px; }
                        .logo { font-size: 32px; font-weight: bold; color: #4A90E2; }
                        .button { display: inline-block; padding: 12px 30px; background-color: #4A90E2; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }
                        .footer { margin-top: 30px; text-align: center; color: #888; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <div class="logo">🎓 MI-TOGA</div>
                        </div>
                        <h2>¡Bienvenido, %s!</h2>
                        <p>Tu cuenta ha sido verificada exitosamente. Ahora puedes disfrutar de todas las funcionalidades de MI-TOGA:</p>
                        <ul>
                            <li>Buscar tutores especializados</li>
                            <li>Agendar sesiones en línea</li>
                            <li>Realizar pagos seguros</li>
                            <li>Videoconferencias en vivo</li>
                        </ul>
                        <div style="text-align: center;">
                            <a href="https://mitoga.com/login" class="button">Iniciar Sesión</a>
                        </div>
                        <div class="footer">
                            <p>© 2025 MI-TOGA - Plataforma de Tutorías en Línea</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nombreCompleto);
    }

    private String buildPasswordRecoveryEmailHtml(String nombreCompleto, String codigo) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { text-align: center; margin-bottom: 30px; }
                        .logo { font-size: 32px; font-weight: bold; color: #4A90E2; }
                        .code-box { background-color: #fff3cd; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0; border-radius: 5px; border: 2px solid #ffc107; }
                        .footer { margin-top: 30px; text-align: center; color: #888; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <div class="logo">🔐 MI-TOGA</div>
                        </div>
                        <h2>Hola, %s!</h2>
                        <p>Recibimos una solicitud para restablecer tu contraseña. Usa el siguiente código:</p>
                        <div class="code-box">%s</div>
                        <p>Este código es válido por <strong>10 minutos</strong>.</p>
                        <p>Si no solicitaste el restablecimiento, <strong>ignora este correo</strong> y tu contraseña permanecerá sin cambios.</p>
                        <div class="footer">
                            <p>© 2025 MI-TOGA - Plataforma de Tutorías en Línea</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nombreCompleto, codigo);
    }

    private String buildPasswordChangedEmailHtml(String nombreCompleto) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { text-align: center; margin-bottom: 30px; }
                        .logo { font-size: 32px; font-weight: bold; color: #4A90E2; }
                        .success-box { background-color: #d4edda; padding: 15px; border-radius: 5px; border: 2px solid #28a745; margin: 20px 0; }
                        .footer { margin-top: 30px; text-align: center; color: #888; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <div class="logo">✅ MI-TOGA</div>
                        </div>
                        <h2>Hola, %s!</h2>
                        <div class="success-box">
                            <p><strong>Tu contraseña ha sido cambiada exitosamente.</strong></p>
                        </div>
                        <p>Si no realizaste este cambio, por favor contacta inmediatamente a soporte@mitoga.com</p>
                        <div class="footer">
                            <p>© 2025 MI-TOGA - Plataforma de Tutorías en Línea</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nombreCompleto);
    }

    private String buildNewSessionEmailHtml(String nombreCompleto, String dispositivo, String ipAddress) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .header { text-align: center; margin-bottom: 30px; }
                        .logo { font-size: 32px; font-weight: bold; color: #4A90E2; }
                        .info-box { background-color: #e7f3ff; padding: 15px; border-radius: 5px; border-left: 4px solid #4A90E2; margin: 20px 0; }
                        .footer { margin-top: 30px; text-align: center; color: #888; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <div class="logo">🔐 MI-TOGA</div>
                        </div>
                        <h2>Nueva Sesión Detectada</h2>
                        <p>Hola, %s!</p>
                        <p>Se ha iniciado una nueva sesión en tu cuenta MI-TOGA:</p>
                        <div class="info-box">
                            <p><strong>Dispositivo:</strong> %s</p>
                            <p><strong>Dirección IP:</strong> %s</p>
                        </div>
                        <p>Si reconoces esta actividad, puedes ignorar este correo. Si no, por favor cambia tu contraseña inmediatamente.</p>
                        <div class="footer">
                            <p>© 2025 MI-TOGA - Plataforma de Tutorías en Línea</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nombreCompleto, dispositivo, ipAddress);
    }
}
