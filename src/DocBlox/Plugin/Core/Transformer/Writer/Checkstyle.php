<?php
/**
 * Checkstyle Transformer File
 *
 * PHP Version 5
 *
 * @category   DocBlox
 * @package    Transformer
 * @subpackage Writers
 * @author     Ben Selby <benmatselby@gmail.com>
 * @copyright  2010-2011 Mike van Riel / Naenius (http://www.naenius.com)
 * @license    http://www.opensource.org/licenses/mit-license.php MIT
 * @link       http://docblox-project.org
 */

/**
 * Checkstyle transformation writer; generates checkstyle report
 *
 * @category   DocBlox
 * @package    Transformer
 * @subpackage Writers
 * @author     Ben Selby <benmatselby@gmail.com>
 * @license    http://www.opensource.org/licenses/mit-license.php MIT
 * @link       http://docblox-project.org
 */
class DocBlox_Plugin_Core_Transformer_Writer_Checkstyle
    extends DocBlox_Transformer_Writer_Abstract
{

    /**
     * This method generates the checkstyle.xml report
     *
     * @param DOMDocument                        $structure      XML source.
     * @param DocBlox_Transformer_Transformation $transformation Transformation.
     *
     * @throws Exception
     *
     * @return void
     */
    public function transform(DOMDocument $structure,
        DocBlox_Transformer_Transformation $transformation
    )
    {
        $artifact = $transformation->getTransformer()->getTarget()
        . DIRECTORY_SEPARATOR . $transformation->getArtifact();

        $list = $structure->getElementsByTagName('parse_markers');

        $document = new DOMDocument();
        $report = $document->createElement('checkstyle');
        $report->setAttribute('version', '1.3.0');
        $document->appendChild($report);

        foreach ($list as $node) {

            $file = $document->createElement('file');
            $file->setAttribute('name', $node->parentNode->getAttribute('path'));
            $report->appendChild($file);

            foreach ($node->childNodes as $error) {

                if ((string)$error->nodeName != '#text') {
                    $item = $document->createElement('error');
                    $item->setAttribute('line', $error->getAttribute('line'));
                    $item->setAttribute('severity', $error->nodeName);
                    $item->setAttribute('message', $error->textContent);
                    $file->appendChild($item);
                }
            }
        }

        file_put_contents($artifact, $document->saveXML());
    }
}