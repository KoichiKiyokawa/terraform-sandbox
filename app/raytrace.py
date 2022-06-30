# Example 12: small scene
#
# This time we render a small scene with shadow

from pyrt.math import Vec3
from pyrt.scene import Scene
from pyrt.light import PointLight
from pyrt.geometry import Triangle, Sphere, Vertex
from pyrt.material import PhongMaterial
from pyrt.camera import PerspectiveCamera
from pyrt.renderer import SimpleRT
from PIL import Image

# Specify width/height as in example 5
width = 160
height = 120


def render(file, index):
    # now create a camera and a view like in example 5:
    camera = PerspectiveCamera(width, height, 45)
    camera.setView(Vec3(0., -10., 10.),  Vec3(0., 0., 0.),  Vec3(0., 0., 1.))

    # Create a scene
    scene = Scene()

    # Add a light to the scene
    scene.addLight(PointLight(Vec3(0, 0, 15)))

    # create some materials:
    color = [
        Vec3(1., 0., 0.),
        Vec3(0., 1., 0.),
        Vec3(0., 0., 1.),
        Vec3(1., 1., 0.),
    ]
    floormaterial = PhongMaterial(color=Vec3(0.1, 0.1, 0.1))
    sphere0material = PhongMaterial(color=color[index[0]], reflectivity=0.5)
    sphere1material = PhongMaterial(color=color[index[1]], reflectivity=0.5)
    sphere2material = PhongMaterial(color=color[index[2]], reflectivity=0.5)
    sphere3material = PhongMaterial(color=color[index[3]], reflectivity=0.5)

    # Add "floor"
    A = Vertex(position=(-5.0, -5.0, 0.0))
    B = Vertex(position=(5.0, -5.0, 0.0))
    C = Vertex(position=(5.0, 5.0, 0.0))
    D = Vertex(position=(-5.0, 5.0, 0.0))

    scene.add(Triangle(A, B, C, material=floormaterial))
    scene.add(Triangle(A, C, D, material=floormaterial))

    # Add some spheres
    scene.add(
        Sphere(
            center=Vec3(-2.5, -2.5, 1.75),
            radius=1.75,
            material=sphere0material
            )
        )
    scene.add(
        Sphere(
            center=Vec3(2.5, -2.5, 1.75),
            radius=1.75,
            material=sphere1material)
        )
    scene.add(
        Sphere(
            center=Vec3(2.5, 2.5, 1.75),
            radius=1.75,
            material=sphere2material)
        )
    scene.add(
        Sphere(
            center=Vec3(-2.5, 2.5, 1.75),
            radius=1.75,
            material=sphere3material)
        )

    # Now tell the scene which camera we use
    scene.setCamera(camera)

    # Create a raytracer using "SimpleRT"
    engine = SimpleRT(shadow=True, iterations=3)

    # Render the scene:
    image = engine.render(scene)
    image.save(file)
