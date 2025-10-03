package com.superpet.ProyectoSuperpet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.superpet.ProyectoSuperpet.model.Cliente;
import com.superpet.ProyectoSuperpet.model.Rol;
import com.superpet.ProyectoSuperpet.model.Usuario;
import com.superpet.ProyectoSuperpet.repository.ClienteRepository;
import com.superpet.ProyectoSuperpet.repository.RolRepository;
import com.superpet.ProyectoSuperpet.repository.UsuarioRepository;
import com.superpet.ProyectoSuperpet.service.UsuarioService;

@Controller
public class RegistroController {

    @Autowired
    private ClienteRepository clienteRepo;

    @Autowired
    private RolRepository rolRepo;

    @Autowired
    private UsuarioRepository usuarioRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/registro")
    public String mostrarFormulario() {
        return "registro"; // templates/registro.html
    }

    @PostMapping("/registro")
    public String registrarUsuario(@RequestParam("nombre") String nombre,
                                   @RequestParam("telefono") String telefono,
                                   @RequestParam("email") String email,
                                   @RequestParam("direccion") String direccion,
                                   @RequestParam("password") String password,
                                   Model model) {
        try {
            // Verificar si el email ya existe
            if (usuarioService.buscarPorEmail(email) != null) {
                model.addAttribute("error", "Ya existe una cuenta con este correo.");
                return "registro";
            }

            // 1. Guardar cliente
            Cliente cliente = new Cliente();
            cliente.setNombre(nombre);
            cliente.setTelefono(telefono);
            cliente.setEmail(email);
            cliente.setDireccion(direccion);
            clienteRepo.save(cliente);

            // 2. Obtener rol CLIENTE desde la BD
            Rol rolCliente = rolRepo.findByNombre("CLIENTE")
                    .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

            // 3. Guardar usuario vinculado al cliente y con rol CLIENTE
            Usuario usuario = new Usuario();
            usuario.setEmail(email);
            usuario.setPassword(passwordEncoder.encode(password));
            usuario.setRol(rolCliente);
            usuario.setCliente(cliente);

            usuarioRepo.save(usuario);

            // 4. Mostrar mensaje de éxito en la misma vista
            model.addAttribute("RegistroExitoso", true);

            return "registro"; // Permanece en la página mostrando mensaje
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error al registrar: " + e.getMessage());
            return "registro";
        }
    }
}
