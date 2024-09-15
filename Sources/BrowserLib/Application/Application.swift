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
        glDisable(GLenum(GL_DEPTH_TEST))
        glDisable(GLenum(GL_CULL_FACE))

        // Loop until the user closes the window
        while !window.shouldClose {
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

            /* Render here */
            // Draw a square
            glColor3f(1, 0, 0)
            glBegin(GLenum(GL_TRIANGLES))
            glVertex2f(-0.5, -0.5)
            glVertex2f(0.5, -0.5)
            glVertex2f(0.5, 0.5)

            glVertex2f(-0.5, -0.5)
            glVertex2f(0.5, 0.5)
            glVertex2f(-0.5, 0.5)
            glEnd()

            window.update()
        }

        window.destroy()
    }
}
