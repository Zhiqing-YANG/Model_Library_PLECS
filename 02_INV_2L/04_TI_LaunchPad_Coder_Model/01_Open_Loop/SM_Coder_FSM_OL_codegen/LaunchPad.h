/*
 * Header file for: SM_Coder_FSM_OL/Circuit/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 5 Aug 2021 17:33:43
 */

#ifndef PLECS_HEADER_LaunchPad_h_
#define PLECS_HEADER_LaunchPad_h_
#include <stdbool.h>
#include <stdint.h>

/* Target declarations */
typedef int_fast8_t int8_t;
typedef uint_fast8_t uint8_t;
extern void LaunchPad_background(void);

/* Model floating point type */
typedef double LaunchPad_FloatType;

/* Model checksum */
extern const char * const LaunchPad_checksum;

/* Model error status */
extern const char * LaunchPad_errorStatus;

/* Model sample time */
extern const double LaunchPad_sampleTime;

/*
 * Model states */
typedef struct {
  double StateMachine[3];              /* /LaunchPad/State Machine */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double TriangularWave;               /* /LaunchPad/Controller/OL/Triangular Wave */
  double StateMachine[6];              /* /LaunchPad/State Machine */
  double SW_OLPLL;                     /* /LaunchPad/SW_OLPLL */
  double Cos;                          /* /LaunchPad/Controller/OL/RRF->3ph/Cos */
  double Sin;                          /* /LaunchPad/Controller/OL/RRF->3ph/Sin */
  double dq_a;                         /* /LaunchPad/Controller/OL/RRF->3ph/dq->a */
  double dq_b;                         /* /LaunchPad/Controller/OL/RRF->3ph/dq->b */
  bool Switch1;                        /* /LaunchPad/Controller/output selector/Switch1 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
