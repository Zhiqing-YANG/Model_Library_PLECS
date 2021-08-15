/*
 * Header file for: SM_Coder_FSM_OL/ Three-Phase 2L Grid-Tied  Inverter/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 13 Aug 2021 14:29:14
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
  double TriangularWave;               /* /LaunchPad/Controller/Modulator/Triangular Wave */
  double Saturation_1[3];              /* /LaunchPad/Controller/Modulator/Saturation */
  double StateMachine[6];              /* /LaunchPad/State Machine */
  double SW_1;                         /* /LaunchPad/SW_1 */
  double Cos;                          /* /LaunchPad/Controller/Modulator/RRF->3ph/Cos */
  double Sin;                          /* /LaunchPad/Controller/Modulator/RRF->3ph/Sin */
  double dq_a;                         /* /LaunchPad/Controller/Modulator/RRF->3ph/dq->a */
  double dq_b;                         /* /LaunchPad/Controller/Modulator/RRF->3ph/dq->b */
  bool LogicalOperator5;               /* /LaunchPad/Protection/Logical Operator5 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
