import Foundation
import GLFW
import OpenGL

@MainActor
class Window {
    private var width: Int
    private var height: Int
    private var title: String

    private var window: GLFWWindow
    var shouldClose: Bool {
        window.shouldClose
    }

    init(width: Int, height: Int, title: String) throws {
        self.width = width
        self.height = height
        self.title = title

        try GLFWSession.initialize()

        GLFWSession.onReceiveError = { error in
            print("GLFW error: \(error)")
        }

        GLFWWindow.hints.contextVersion = (3, 3)
        GLFWWindow.hints.openGLProfile = .core
        GLFWWindow.hints.openGLCompatibility = .forward

        // Create a windowed mode window and its OpenGL context
        window = try GLFWWindow(width: width, height: height, title: title)

        // Make the window's context current
        window.context.makeCurrent()

        // Set the viewport to cover the entire window
        glViewport(0, 0, GLsizei(width), GLsizei(height))
    }

    func update() {
        // Swap front and back buffers
        window.swapBuffers()

        // Poll for and process events
        GLFWSession.pollInputEvents()
    }

    func destroy() {
        GLFWSession.terminate()
    }
}
