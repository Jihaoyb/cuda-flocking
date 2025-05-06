#version 330

uniform mat4 u_projMatrix;
uniform vec3 u_viewDir; // Camera view direction

layout(points) in;
layout(line_strip) out;
layout(max_vertices = 4) out; // 3 for triangle, 1 to close

in vec4 vFragColorVs[];
out vec4 vFragColor;

void main() {
    vec3 Position = gl_in[0].gl_Position.xyz;
    vec3 Velocity = vFragColorVs[0].xyz;
    vec4 boidColor = vFragColorVs[0];
    float triLength = 0.03;   // Length from base to tip
    float triWidth = 0.015;   // Width of the base

    // Direction of velocity
    vec3 dir = normalize(Velocity);
    if (length(Velocity) < 0.0001) dir = vec3(0, 1, 0);

    // Use camera view direction to construct base
    vec3 baseVec = normalize(cross(dir, u_viewDir));
    if (length(baseVec) < 0.0001) baseVec = vec3(1, 0, 0); // fallback

    // Triangle tip (in velocity direction)
    vec3 tip = Position - dir * triLength;

    // Base left and right
    vec3 left = Position + baseVec * triWidth * 0.5;
    vec3 right = Position - baseVec * triWidth * 0.5;

    // Emit triangle outline
    gl_Position = u_projMatrix * vec4(tip, 1.0);
    vFragColor = boidColor;
    EmitVertex();

    gl_Position = u_projMatrix * vec4(left, 1.0);
    vFragColor = boidColor;
    EmitVertex();

    gl_Position = u_projMatrix * vec4(right, 1.0);
    vFragColor = boidColor;
    EmitVertex();

    // Close the triangle
    gl_Position = u_projMatrix * vec4(tip, 1.0);
    vFragColor = boidColor;
    EmitVertex();

    EndPrimitive();
}