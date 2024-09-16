import Foundation
import GLFW
import OpenGL

@MainActor
public class Application {
    private let window: Window

    public init() throws {
        window = try Window(width: 640, height: 480, title: "BrowserJam")
    }

    public func start() throws {
        var vertices: [GLfloat] = [
            0.5, 0.5, 0.0,  // Top Right
            0.5, -0.5, 0.0,  // Bottom Right
            -0.5, -0.5, 0.0,  // Bottom Left
            -0.5, 0.5, 0.0,  // Top Left
        ]
        var indices: [GLuint] = [
            0, 1, 3,
            1, 2, 3,
        ]

        /* Vertex Buffer Object (VBO) */
        var VBO: GLuint = 0
        glGenBuffers(1, &VBO)
        defer { glDeleteBuffers(1, &VBO) }

        /* Element Buffer Object (EBO) */
        var EBO: GLuint = 0
        glGenBuffers(1, &EBO)
        defer { glDeleteBuffers(1, &EBO) }

        /* Shader Program */
        let vertexShaderSource = try String(contentsOfFile: "Shaders/shader.vert", encoding: .utf8)
        let vertexShader = vertexShaderSource.withCString { text in
            let vertexShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
            glShaderSource(vertexShader, 1, [text], nil)
            glCompileShader(vertexShader)
            return vertexShader
        }

        var logLength: GLint = 0
        glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log = [GLchar](repeating: 0, count: Int(logLength))
            glGetShaderInfoLog(vertexShader, logLength, nil, &log)
            print(String(cString: log))
        }

        var success: GLint = 0
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &success)
        guard success == GL_TRUE else {
            fatalError("Failed to compile vertex shader")
        }

        let fragmentShaderSource = try String(
            contentsOfFile: "Shaders/shader.frag", encoding: .utf8)
        let fragmentShader = fragmentShaderSource.withCString {
            let fragmentShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
            glShaderSource(fragmentShader, 1, [$0], nil)
            glCompileShader(fragmentShader)
            return fragmentShader
        }

        glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log = [GLchar](repeating: 0, count: 512)
            glGetShaderInfoLog(fragmentShader, 512, nil, &log)
            print(String(cString: log))
        }

        success = 0
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &success)
        guard success == GL_TRUE else {
            fatalError("Failed to compile fragment shader")
        }

        let shaderProgram = glCreateProgram()
        defer { glDeleteProgram(shaderProgram) }

        glAttachShader(shaderProgram, vertexShader)
        glAttachShader(shaderProgram, fragmentShader)
        glLinkProgram(shaderProgram)

        glGetProgramiv(shaderProgram, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log = [GLchar](repeating: 0, count: 512)
            glGetProgramInfoLog(shaderProgram, 512, nil, &log)
            print(String(cString: log))
        }

        success = 0
        glGetProgramiv(shaderProgram, GLenum(GL_LINK_STATUS), &success)
        guard success == GL_TRUE else {
            fatalError("Failed to link program")
        }

        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)

        let posAttrib = glGetAttribLocation(shaderProgram, "in_Position")

        /* Vertex Array Object (VAO) */
        var VAO: GLuint = 0
        glGenVertexArrays(1, &VAO)
        defer { glDeleteVertexArrays(1, &VAO) }

        // 1. Bind VAO
        glBindVertexArray(VAO)

        // 2. Copy our vertices array into a VBO
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.stride * vertices.count, &vertices,
            GLenum(GL_STATIC_DRAW))

        // 3. Copy our indices array into an EBO
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.stride * indices.count, &indices,
            GLenum(GL_STATIC_DRAW))

        // 4. Set vertex attributes pointers
        glEnableVertexAttribArray(GLuint(posAttrib))
        glVertexAttribPointer(
            GLuint(posAttrib), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<GLfloat>.stride * 3), nil)

        // 5. Unbind VAO (not EBO)
        glBindVertexArray(0)

        /* Drawing code */
        // glPolygonMode(GLenum(GL_FRONT_AND_BACK), GLenum(GL_LINE))

        // Loop until the user closes the window
        while !window.shouldClose {
            glClearColor(0.2, 0.3, 0.3, 1.0)
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

            glUseProgram(shaderProgram)
            glBindVertexArray(VAO)
            glDrawElements(GLenum(GL_TRIANGLES), 6, GLenum(GL_UNSIGNED_INT), nil)
            glBindVertexArray(0)

            window.update()
        }

        window.destroy()
    }
}
