/// Ciudades de Colombia que la app ofrece al reportar un siniestro (M05-03).
///
/// Copia de `contracts/ciudades.json` del backend (`solventa-backend`): si cambia allá, se actualiza aquí. El nombre
/// es el texto canónico que viaja en `ubicacion.ciudad`; las ciudades de los prestadores (los marcadores del mapa)
/// salen del mismo catálogo.
final class Ciudad {
  const Ciudad(this.nombre, this.departamento);

  final String nombre;
  final String departamento;
}

const ciudadesColombia = <Ciudad>[
  Ciudad('Bogotá', 'Bogotá D.C.'),
  Ciudad('Medellín', 'Antioquia'),
  Ciudad('Cali', 'Valle del Cauca'),
  Ciudad('Barranquilla', 'Atlántico'),
  Ciudad('Cartagena', 'Bolívar'),
  Ciudad('Cúcuta', 'Norte de Santander'),
  Ciudad('Bucaramanga', 'Santander'),
  Ciudad('Pereira', 'Risaralda'),
  Ciudad('Santa Marta', 'Magdalena'),
  Ciudad('Ibagué', 'Tolima'),
  Ciudad('Manizales', 'Caldas'),
  Ciudad('Villavicencio', 'Meta'),
  Ciudad('Pasto', 'Nariño'),
  Ciudad('Montería', 'Córdoba'),
  Ciudad('Neiva', 'Huila'),
  Ciudad('Armenia', 'Quindío'),
  Ciudad('Valledupar', 'Cesar'),
  Ciudad('Popayán', 'Cauca'),
  Ciudad('Sincelejo', 'Sucre'),
  Ciudad('Tunja', 'Boyacá'),
  Ciudad('Riohacha', 'La Guajira'),
  Ciudad('Florencia', 'Caquetá'),
  Ciudad('Yopal', 'Casanare'),
  Ciudad('Quibdó', 'Chocó'),
  Ciudad('Soacha', 'Cundinamarca'),
  Ciudad('Bello', 'Antioquia'),
  Ciudad('Itagüí', 'Antioquia'),
  Ciudad('Envigado', 'Antioquia'),
  Ciudad('Soledad', 'Atlántico'),
  Ciudad('Palmira', 'Valle del Cauca'),
  Ciudad('Buenaventura', 'Valle del Cauca'),
  Ciudad('Floridablanca', 'Santander'),
  Ciudad('Dosquebradas', 'Risaralda'),
  Ciudad('Tuluá', 'Valle del Cauca'),
  Ciudad('Barrancabermeja', 'Santander'),
  Ciudad('Sogamoso', 'Boyacá'),
];
