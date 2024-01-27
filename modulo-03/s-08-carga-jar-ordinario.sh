#!/bin/bash
echo "Creando archivo ResizeImage.java"
mkdir -p mx/edu/unam/fi/dipbd/

echo "creando la clase ResizeImage.java"

cat <<EOF > mx/edu/unam/fi/dipbd/ResizeImage.java

package mx.edu.unam.fi.dipbd;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

/**
 * Utility class used to resize an Image using {@link Graphics2D}
 */

public class ResizeImage {

  /**
   * Método encargado de modificar el tamaño de una imagen. La imagen
   * modificada será almacenada en el mismo directorio con el nombre
   * output-<nombre-archivo>
   * @param imgPath Ruta absoluta donde se encuentra la imagen origen
   * @param targetWidth Ancho de la imagen
   * @param targetHeight Alto de la imagen
   * @throws IOException Si ocurre un error.
   */

  public static void resizeImage(String imgPath, int targetWidth, int targetHeight)
    throws IOException {
    System.out.println("Procesando imagen " + imgPath);
    File imgFile = new File(imgPath);
    BufferedImage srcImg = ImageIO.read(imgFile);
    Image outputImg =
      srcImg.getScaledInstance(targetWidth, targetHeight, Image.SCALE_DEFAULT);
    BufferedImage outputImage =
      new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
    outputImage.getGraphics().drawImage(outputImg, 0, 0, null);
    System.out.println("Escribiendo imagen ");
    String outputName = "output-" + imgFile.getName();
    File outputFile = new File(imgFile.getParent(), outputName);
    ImageIO.write(outputImage, "png", outputFile);
  }
}
EOF

echo "Creando archivo jar"
rm -f  ejemplo-java-img.jar
$ORACLE_HOME/jdk/bin/jar cf ejemplo-java-img.jar mx
echo "Mostrando el contenido del archivo Jar"
unzip -l ejemplo-java-img.jar

echo "Dar de baja la clase Java de la BD, se intenta eliminar en caso de existir"
dropjava -user userJava/userJava mx/edu/unam/fi/dipbd/ResizeImage

echo "Cargando archivo Jar en BD"
loadjava -user userJava/userJava ejemplo-java-img.jar 

echo "copiando imagen al directorio /tmp"
cp paisaje.png /tmp
chmod 744 /tmp/paisaje.png

echo "Listo!"
